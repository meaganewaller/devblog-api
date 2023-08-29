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

  def fetch_records(database_id, filter = {})
    records = []
    @client.database_query(database_id: database_id, filter: filter) do |page|
      records.concat(page.results)
    end
    records
  end

  def fetch_categories
    categories = fetch_records(ENV["NOTION_CATEGORY_DATABASE_ID"])
    categories.map do |category|
      {
        notion_id: category.fetch(:id),
        title: category.properties.Name.title.first.plain_text,
        description: category.properties.Description.rich_text.first.plain_text,
        last_edited_time: category.last_edited_time.to_datetime,
      }
    end
  end

  def fetch_posts
    posts = fetch_records(ENV["NOTION_BLOG_DATABASE_ID"], { property: "Type", select: { equals: "Post" } })
    binding.pry
    posts.map do |post|
      {
        notion_id: post.fetch(:id),
        title: post.properties.Title.title.first.plain_text,
        description: post.properties.Summary&.rich_text&.reduce("") { |acc, curr| acc + curr.plain_text },
        published: post.properties.Published.checkbox,
        published_date: post.properties.Published.checkbox ? post.properties.Date.date.start : nil,
        notion_slug: post.properties.Slug&.rich_text&.first&.plain_text,
        notion_created_at: post.properties.Created.created_time.to_datetime,
        notion_updated_at: post.last_edited_time.to_datetime,
        tags: post.properties.Tags.multi_select.map(&:name),
        category_notion_id: post.properties["Content Pillar"].relation[0]&.id,
        status: post.properties.Status.status.name,
        cover_image: post.properties["Cover Image"]&.files&.first,
        meta_description: post.properties["Meta Description"].rich_text&.reduce("") { |acc, curr| acc + curr.plain_text },
        meta_keywords: post.properties["Meta Keywords"].multi_select.map { |kw| kw["name"] },
      }
    end
  end
end
