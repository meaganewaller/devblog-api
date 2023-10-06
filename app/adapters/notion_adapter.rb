class NotionAdapter
  def self.fetch_categories
    new.fetch_categories
  end

  def self.fetch_posts
    new.fetch_posts
  end

  def initialize(client = Notion::Client.new)
    @client = client
  end

  def fetch_records(database_id, filter = nil)
    records = []
    if filter
      @client.database_query(database_id: database_id, filter: filter) do |page|
        records.concat(page.results)
      end
    else
      @client.database_query(database_id: database_id) do |page|
        records.concat(page.results)
      end
    end
    records
  end

  def fetch_categories
    categories = fetch_records(ENV["NOTION_CATEGORY_DATABASE_ID"])
    categories.map do |category|
      {
        notion_id: category.send(:id),
        title: category.properties.Name.title.first.plain_text,
        description: category.properties.Description.rich_text.first.plain_text,
        last_edited_time: category.last_edited_time.to_datetime
      }
    end
  end

  # Updated fetch_posts method
  def fetch_posts
    posts = fetch_records(ENV["NOTION_BLOG_DATABASE_ID"], { property: "Type", select: { equals: "Post" } })
    posts.map do |post|
      content = blocks_children(post.send(:id))
      date_property = post.properties.Date&.date
      published_date = date_property ? date_property.start : nil

      {
        notion_id: post.send(:id),
        title: post.properties.Title&.title&.first&.plain_text || '', # Handle nil values gracefully
        description: post.properties.Summary&.rich_text&.reduce("") { |acc, curr| acc + curr.plain_text } || '', # Handle nil values gracefully
        published: post.properties.Published&.checkbox || false, # Handle nil values gracefully
        published_date: published_date, # Use the extracted date
        notion_slug: post.properties.Slug&.rich_text&.first&.plain_text || '', # Handle nil values gracefully
        notion_created_at: DateTime.parse(post.properties.Created.created_time),
        notion_updated_at: DateTime.parse(post.last_edited_time),
        tags: post.properties.Tags&.multi_select&.map(&:name) || [], # Handle nil values gracefully
        category_notion_id: post.properties["Content Pillar"]&.relation&.first&.id || '', # Handle nil values gracefully
        status: post.properties.Status&.status&.name || '', # Handle nil values gracefully
        cover_image: post.properties["Cover Image"]&.files&.first || '', # Handle nil values gracefully
        meta_description: post.properties["Meta Description"]&.rich_text&.reduce("") { |acc, curr| acc + curr.plain_text } || '', # Handle nil values gracefully
        meta_keywords: post.properties["Meta Keywords"]&.multi_select&.map { |kw| kw["name"] } || [], # Handle nil values gracefully
        content:,
      }
    end
  end

  private

  def blocks_children(page_id)
    all_blocks = []
    @client.block_children(block_id: page_id) do |page|
      all_blocks.concat(page.results)
    end
    all_blocks.reduce("") { |acc, curr| acc + to_md(curr) }
  end

  def to_md(block)
    prefix = ''
    suffix = ''

    case block['type']
    when 'paragraph'
      # do nothing
    when /heading_(\d)/
      prefix = "\n\n#" * Regexp.last_match(1).to_i + ' '
      block["#{block['type']}"]['rich_text'].map { _1['annotations']['bold'] = false } # unbold headings
      suffix = "\n\n"
    when 'callout'
      # do nothing
    when 'quote'
      prefix = '> '
    when 'bulleted_list_item'
      prefix = '- '
    when 'numbered_list_item'
      prefix = '1. '
    when 'to_do'
      prefix = block.to_do['checked'] ? '- [x] ' : '- [ ] '
    when 'toggle'
      # do nothing
    when 'code'
      prefix = "\n```#{block['code']['language'].split.first}\n"
      suffix = "\n```\n"
    when 'image'
      return "![#{RichText.to_md(block.image['caption'])}](#{block.image[block.image['type']]['url']})"
    when 'equation'
      return "$$#{block.equation['expression']}$$"
    when 'divider'
      return '---'
    else
      raise 'Unable to convert the block'
    end

    # Only for types with rich_text, others should return in `case`
    prefix + RichText.to_md(block["#{block['type']}"]['rich_text']) + suffix
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
      return " $#{md}$ " if type == 'equation'

      md = " <u>#{md}</u> "       if annotations['underline']
      md =   " `#{md}` "          if annotations['code']
      md =  " **#{md}** "         if annotations['bold']
      md =   " *#{md}* "          if annotations['italic']
      md =  " ~~#{md}~~ "         if annotations['strikethrough']
      md =   " [#{md}](#{href}) " if href
      md
    end
  end
end
