class PostFetcherJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = Notion::Client.new
    all_posts = []
    client.database_query(database_id: ENV['NOTION_BLOG_DATABASE_ID']) do |page|
      all_posts.concat(page.results)
    end

unless all_posts.empty?
    all_posts.each do |post|
        next if Post.exists?(notion_id: post.id)
        notion_converter = NotionToMd::Converter.new(page_id: post.id)
        content = notion_converter.convert

        Post.create(
          notion_id: post.id,
          title: post.properties.Title.title.first.plain_text,
          description: get_description(post.properties.Description),
          published_date: post.properties.Published.checkbox ? post.properties.Date.date.start : nil,
          published: post.properties.Published.checkbox,
          notion_slug: post.properties.Slug.rich_text.first.plain_text,
          tags: get_tags(post.properties.Tags),
          content: content,
          notion_created_at: post.properties.Created.created_time.to_datetime,
          notion_updated_at: post.last_edited_time.to_datetime,
        )
      end
    end
  end

  def get_tags(tags)
    if tags.has_key?("multi_select")
      tags.multi_select.map { |tag| tag.name }
    end
  end

  def get_description(description)
    if description.has_key?("rich_text")
      description.rich_text.reduce("") { |desc, txt|  desc + txt.plain_text }
    else
      "Still need a description"
    end
  end
end
