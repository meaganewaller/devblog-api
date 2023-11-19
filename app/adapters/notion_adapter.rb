# frozen_string_literal: true

class NotionAdapter
  DATABASE_IDS = {
    category: ENV["NOTION_CATEGORY_DATABASE_ID"],
    blog: ENV["NOTION_BLOG_DATABASE_ID"],
    project: ENV["NOTION_PROJECT_DATABASE_ID"]
  }.freeze

  PROPERTY_NAMES = {
    title: "Title",
    summary: "Summary",
    date: "Date",
    cover_image: "Cover Image"
  }.freeze

  def self.fetch_categories
    new.fetch_categories
  end

  def self.fetch_posts
    new.fetch_posts
  end

  def self.fetch_projects
    new.fetch_projects
  end

  def initialize(client = Notion::Client.new)
    @client = client
  end

  def fetch_categories
    fetch_records(DATABASE_IDS[:category]).map do |category|
      transform_category(category)
    end
  end

  def fetch_posts
    fetch_records(
      DATABASE_IDS[:blog],
      blog_post_filters,
      blog_post_sorts
    ).map do |post|
      transform_post(post)
    end
  end

  def fetch_projects
    fetch_records(DATABASE_IDS[:project]).map do |project|
      transform_project(project)
    end
  end

  private

  def blog_post_sorts
    [
      {
        property: "Date",
        direction: "descending"
      }
    ]
  end

  def blog_post_filters
    {
      property: "Type",
      select: {
        equals: "Post"
      }
    }
  end

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

  def transform_post(post)
    properties = post.properties
    published_date = extract_published_date(properties)
    {
      notion_id: post.id,
      title: from_title(properties[PROPERTY_NAMES[:title]]),
      description: from_rich_text(properties[PROPERTY_NAMES[:summary]]),
      published: properties.Published&.checkbox || false,
      published_date:,
      notion_slug: from_rich_text(properties.Slug),
      notion_created_at: DateTime.parse(properties.Created.created_time),
      notion_updated_at: DateTime.parse(post.last_edited_time),
      tags: extract_tags(properties),
      status: extract_status(properties),
      category_notion_id: extract_category_id(properties),
      cover_image: from_files(properties[PROPERTY_NAMES[:cover_image]]),
      meta_description: from_rich_text(properties["Meta Description"]),
      meta_keywords: from_rich_text(properties["Meta Keywords"]),
      content: blocks_children(post.id)
    }
  end

  def extract_published_date(properties)
    date_property = properties[PROPERTY_NAMES[:date]]&.date
    date_property&.start
  end

  def extract_tags(properties)
    properties.Tags&.multi_select&.map(&:name) || []
  end

  def extract_status(properties)
    properties.Status&.status&.name || ""
  end

  def extract_category_id(properties)
    properties["Content Pillar"]&.relation&.first&.id || ""
  end

  def transform_project(project)
    properties = project.properties
    {
      notion_id: project.id,
      title: from_title(properties[PROPERTY_NAMES[:title]]),
      description: from_rich_text(properties[PROPERTY_NAMES[:summary]]),
      notion_created_at: DateTime.parse(properties.Created.created_time),
      status: extract_status(properties),
      cover_image: from_files(properties[PROPERTY_NAMES[:cover_imagee]])
    }
  end

  def from_rich_text(property)
    property&.rich_text&.reduce("") { |acc, curr| acc + curr.plain_text } || ""
  end

  def from_files(property)
    property&.files&.first || ""
  end

  def from_title(property)
    property&.title&.first&.plain_text
  end

  def blocks_children(page_id)
    all_blocks = []
    @client.block_children(block_id: page_id) do |page|
      all_blocks.concat(page.results)
    end
    all_blocks.reduce("") { |acc, curr| acc + to_md(curr) }
  end

  def to_md(block)
    prefix = ""
    suffix = ""

    case block["type"]
    when "paragraph"
      # do nothing
    when /heading_(\d)/
      prefix = "#{"\n\n#" * Regexp.last_match(1).to_i} "
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
