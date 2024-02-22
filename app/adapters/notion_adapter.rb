# frozen_string_literal: true

# This class is responsible for interacting with the Notion API.
# It fetches and transforms records from different Notion databases.
#
# @example Fetching categories
#   NotionAdapter.fetch_categories
#
# @example Fetching posts
#   NotionAdapter.fetch_posts
#
# @example Fetching projects
#   NotionAdapter.fetch_projects
class NotionAdapter
  # @return [Hash] the IDs of the Notion databases
  DATABASE_IDS = {
    blog: ENV["NOTION_BLOG_DATABASE_ID"],
    category: ENV["NOTION_CATEGORY_DATABASE_ID"],
    project: ENV["NOTION_PROJECT_DATABASE_ID"]
  }.freeze

  PROPERTY_NAMES = {
    author: "Author",
    cover_image: "Cover Image",
    date: "Date",
    last_edited_time: "Last edited time",
    meta_description: "Meta Description",
    published: "Published",
    summary: "Summary",
    title: "Name"
  }.freeze

  class << self
    # Service method to fetch categories from the Notion database.
    #
    # @return [Array] an array of transformed categories
    def fetch_categories
      new.fetch_categories
    end

    # Service method to fetch posts from the Notion database.
    #
    # @return [Array] an array of transformed posts
    def fetch_posts
      new.fetch_posts
    end

    # Service method to fetch projects from the Notion database.
    #
    # @return [Array] an array of transformed projects
    def fetch_projects
      new.fetch_projects
    end
  end

  # Initializes a new instance of the NotionAdapter class.
  #
  # @param client [Notion::Client] the Notion client
  # @return [NotionAdapter] the NotionAdapter instance
  def initialize(client = Notion::Client.new)
    @client = client
  end

  # Fetches categories from the Notion database.
  # @return [Array] an array of transformed categories
  def fetch_categories
    fetch_records(DATABASE_IDS[:category]).map do |category|
      transform_category(category)
    end
  end

  # Fetches posts from the Notion database.
  # @return [Array] an array of transformed posts
  def fetch_posts
    fetch_records(
      DATABASE_IDS[:blog],
      blog_post_filters,
      blog_post_sorts
    ).map do |post|
      transform_post(post)
    end
  end

  # Fetches projects from the Notion database.
  # @return [Array] an array of transformed projects
  def fetch_projects
    fetch_records(DATABASE_IDS[:project]).map do |project|
      transform_project(project)
    end
  end

  private

  # @return [Array] an array of blog post sorts
  def blog_post_sorts
    [
      {
        property: "Date",
        direction: "descending"
      }
    ]
  end

  # @return [Hash] the filters for blog posts
  def blog_post_filters
    {
      property: "Type",
      select: {
        equals: "Post"
      }
    }
  end

  # Fetches records from the Notion database.
  #
  # @param database_id [String] the ID of the Notion database
  # @param filter      [Hash] the filter for the records
  # @param sorts       [Array] the sorts for the records
  # @return [Array]    an array of records
  def fetch_records(database_id, filter = nil, sorts = nil)
    records = []
    query_options = {database_id:}
    query_options[:filter] = filter if filter
    query_options[:sorts] = sorts if sorts

    @client.database_query(query_options) do |page|
      records.concat(page.results)
    end
    records
  end

  # Transforms a category record from the Notion database.
  #
  # @param category [Notion::Block] the category record
  # @return         [Hash] the transformed category
  def transform_category(category)
    properties = category.properties

    {
      notion_id: category.id,
      title: from_title(properties[PROPERTY_NAMES[:title]]),
      description: from_rich_text(properties[PROPERTY_NAMES[:summary]]),
      cover_image: from_files(properties[PROPERTY_NAMES[:cover_image]]),
      last_edited_time: category.last_edited_time.to_datetime
    }
  end

  # Transforms a post record from the Notion database.
  #
  # @param post [Notion::Block] the post record
  # @return [Hash] the transformed post
  def transform_post(post)
    properties = post.properties
    published_date = extract_published_date(properties)
    {
      notion_id: post.id,
      content: NotionToMd.convert(page_id: post.id),
      title: from_title(properties[PROPERTY_NAMES[:title]]),
      description: from_rich_text(properties[PROPERTY_NAMES[:summary]]),
      published: properties.Published&.checkbox || false,
      published_date:,
      notion_created_at: DateTime.parse(properties.Created.created_time),
      notion_updated_at: DateTime.parse(post.last_edited_time),
      tags: extract_tags(properties),
      category_notion_id: extract_category_id(properties),
      cover_image: from_files(properties[PROPERTY_NAMES[:cover_image]]),
      meta_description: from_rich_text(properties["Meta Description"]),
    }
  end

  # Extracts the published date from the properties of a post.
  #
  # @param properties [Hash] the properties of a post
  # @return [DateTime] the published date
  # @return [nil] if the published date is not found
  # @return [nil] if the published date is not a valid date
  def extract_published_date(properties)
    date_property = properties[PROPERTY_NAMES[:date]]&.date
    date_property&.start
  end

  # Extracts the tags from the properties of a post.
  #
  # @param properties [Hash] the properties of a post
  # @return [Array] an array of tags
  # @return [nil] if the tags are not found
  # @return [nil] if the tags are not a multi-select property
  # @return [nil] if the tags are not an array
  # @return [nil] if the tags are not a valid array
  # @return [nil] if the tags are not valid strings
  def extract_tags(properties)
    properties.Tags&.multi_select&.map(&:name) || []
  end

  # Extracts the status from the properties of a project.
  #
  # @param properties [Hash] the properties of a project
  # @return [String] the status
  # @return [nil] if the status is not found
  # @return [nil] if the status is not a status property
  # @return [nil] if the status is not a valid status
  # @return [nil] if the status is not a valid string
  # @return [nil] if the status is not a valid name
  # @return [nil] if the status is not a valid status name
  # @return [nil] if the status is not a valid status name string
  def extract_status(properties)
    properties.Status&.status&.name || ""
  end

  # Extracts the category ID from the properties of a project.
  #
  # @param properties [Hash] the properties of a project
  # @return [String] the category ID
  # @return [nil] if the category ID is not found
  # @return [nil] if the category ID is not a relation property
  # @return [nil] if the category ID is not a valid relation
  # @return [nil] if the category ID is not a valid ID
  # @return [nil] if the category ID is not a valid string
  # @return [nil] if the category ID is not a valid relation ID
  # @return [nil] if the category ID is not a valid relation ID string
  def extract_category_id(properties)
    properties["Content Pillar"]&.relation&.first&.id || ""
  end

  # Extracts the repository names from the properties of a project.
  #
  # @param repo_names [Array] an array of repository names
  # @return [Array] an array of repository names
  # @return [nil] if the repository names are not found
  # @return [nil] if the repository names are not a rollup property
  # @return [nil] if the repository names are not an array
  # @return [nil] if the repository names are not a valid array
  # @return [nil] if the repository names are not valid strings
  # @return [nil] if the repository names are not valid names
  # @return [nil] if the repository names are not valid name strings
  # @return [nil] if the repository names are not valid name strings
  def extract_repository_names(repo_names)
    names = repo_names&.rollup&.array || []

    names.map! do |repo_name|
      repo_name&.title&.map(&:plain_text)&.join(" ")
    end
  end

  # Extracts the repository links from the properties of a project.
  #
  # @param repo_links [Array] an array of repository links
  # @return [Array] an array of repository links
  # @return [nil] if the repository links are not found
  # @return [nil] if the repository links are not a rollup property
  # @return [nil] if the repository links are not an array
  # @return [nil] if the repository links are not a valid array
  # @return [nil] if the repository links are not valid strings
  def extract_repository_links(repo_links)
    links = repo_links&.rollup&.array || []

    links.map! do |repo_link|
      repo_link&.url
    end
  end

  # Transforms a project record from the Notion database.
  #
  # @param project [Notion::Block] the project record
  # @return [Hash] the transformed project
  # @return [nil] if the project is not found
  # @return [nil] if the project is not a valid project
  # @return [nil] if the project is not a valid project record
  # @return [nil] if the project is not a valid project record hash
  def transform_project(project)
    properties = project.properties

    repository_links = extract_repository_links(properties["Repository Links"])
    repository_names = extract_repository_names(properties["Repository Names"])

    {
      content: NotionToMd.convert(page_id: project.id),
      creation_date: DateTime.parse(properties["Creation Date"]&.date&.start),
      description: from_rich_text(properties[PROPERTY_NAMES[:summary]]),
      link: properties["Link"]&.url || "",
      notion_created_at: DateTime.parse(properties.Created.created_time),
      notion_id: project.id,
      notion_updated_at: DateTime.parse(project.last_edited_time),
      repository_links: repository_links.zip(repository_names).map { |website, name| {website:, name:} },
      tags: properties.Tags&.multi_select&.map(&:name) || [],
      title: from_title(properties[PROPERTY_NAMES[:title]]),
      cover_image: from_files(properties[PROPERTY_NAMES[:cover_image]])
    }
  end

  # Extracts the plain text from a rich text property.
  #
  # @param property [Hash] the rich text property
  # @return [String] the plain text
  # @return [nil] if the plain text is not found
  # @return [nil] if the plain text is not a valid plain text
  def from_rich_text(property)
    property&.rich_text&.reduce("") { |acc, curr| acc + curr.plain_text } || ""
  end

  # Extracts the files from a files property.
  #
  # @param property [Hash] the files property
  # @return [String] the files
  # @return [nil] if the files are not found
  # @return [nil] if the files are not a valid files
  # @return [nil] if the files are not a valid files array
  # @return [nil] if the files are not a valid files array string
  # @return [nil] if the files are not a valid files array string URL
  # @return [nil] if the files are not a valid files array string URL string
  def from_files(property)
    property&.files&.first || ""
  end

  # Extracts the title from a title property.
  #
  # @param property [Hash] the title property
  # @return [String] the title
  # @return [nil] if the title is not found
  # @return [nil] if the title is not a valid title
  # @return [nil] if the title is not a valid title array
  # @return [nil] if the title is not a valid title array string
  def from_title(property)
    property&.title&.first&.plain_text
  end

  # Fetches the children of a block.
  #
  # @param page_id [String] the ID of the page
  # @return [String] the children of the block
  # @return [nil] if the children are not found
  def blocks_children(page_id)
    all_blocks = []
    @client.block_children(block_id: page_id) do |page|
      all_blocks.concat(page.results)
    end
    all_blocks.reduce("") { |acc, curr| acc + RichText.to_md(curr) }
  end

  # Converts a block to markdown.
  #
  # @param block [Hash] the block
  # @return [String] the markdown
  # @return [nil] if the block is not found
  # @return [nil] if the block is not a valid block
  # @return [nil] if the block is not a valid block hash
  # @return [nil] if the block is not a valid block hash string
  # @return [nil] if the block is not a valid block hash string URL
  # @return [nil] if the block is not a valid block hash string URL string
  def to_md(block)
    prefix = ""
    suffix = ""

    case block["type"]
    when "paragraph"
      # do nothing
    when /heading_(\d)/
      prefix = "#{"\n\n" + "#" * Regexp.last_match(1).to_i} "
      block[block["type"].to_s]["rich_text"].map { _1["annotations"]["bold"] = false } # unbold headings
      suffix = "\n\n"
    when "callout"
      # do nothing
    when "quote"
      prefix = "> "
    when "bulleted_list_item"
      prefix = "- "
    when "numbered_list_item"
      prefix = "1. "
    when "to_do"
      prefix = block.to_do["checked"] ? "- [x] " : "- [ ] "
    when "toggle"
      return "\n\n\n#{from_rich_text(block.toggle)}\n\n\n"
    when "table"
      # do nothing
    when "code"
      prefix = "\n```#{block["code"]["language"].split.first}\n"
      suffix = "\n```\n"
    when "image"
      return "![#{RichText.to_md(block.image["caption"])}](#{block.image[block.image["type"]]["url"]})"
    when "equation"
      return "$$#{block.equation["expression"]}$$"
    when "divider"
      return "---"
    else
      raise "Unable to convert the block"
    end
    # Only for types with rich_text, others should return in `case`
    prefix + RichText.to_md(block[block["type"].to_s]["rich_text"]) + suffix
  rescue RuntimeError => e
    puts "#{e.message}: #{JSON.pretty_generate(to_h)}"
    "```json\n#{JSON.pretty_generate(to_h)}\n```"
  end

  class RichText
    ATTRIBUTES = %w[
      plain_text href annotations type text mention equation
    ].each { attr_reader _1 }

    def self.to_md(obj)
      return "" unless obj

      obj.is_a?(Array) ? obj.map { |item| new(item).to_md }.join : new(obj).to_md
    end

    def initialize(data)
      ATTRIBUTES.each { instance_variable_set("@#{_1}", data[_1]) }
    end

    def to_md
      md = plain_text

      # Shortcut for equation
      return " $#{md}$ " if type == "equation"

      md = " <u>#{md}</u> " if annotations["underline"]
      md = " `#{md}` " if annotations["code"]
      md = " **#{md}** " if annotations["bold"]
      md = " *#{md}* " if annotations["italic"]
      md = " ~~#{md}~~ " if annotations["strikethrough"]
      md = " [#{md}](#{href}) " if href
      md
    end
  end
end
