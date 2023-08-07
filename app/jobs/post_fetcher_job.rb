# frozen_string_literal: true

class PostFetcherJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = Notion::Client.new
    all_posts = []
    client.database_query(database_id: ENV["NOTION_BLOG_DATABASE_ID"]) do |page|
      all_posts.concat(page.results)
    end

    return if all_posts.empty?

    all_posts.each do |post|
      found_post = Post.find_by(notion_id: post.id)
      next if found_post && found_post.notion_updated_at == post.last_edited_time.to_datetime

      update_post(found_post, post) if found_post
      create_post(post)
    end
  end

  private

  def update_post(found_post, post)
    notion_converter = NotionToMd::Converter.new(page_id: post.id)
    content = notion_converter.convert
    properties = post.properties

    found_post.update(
      title: properties.Title.title.first.plain_text,
      description: get_description(properties.Description),
      published: properties.Published.checkbox,
      published_date: properties.Published.checkbox ? properties.Date.date.start : nil,
      notion_slug: properties.Slug&.rich_text&.first&.plain_text,
      notion_created_at: properties.Created.created_time.to_datetime,
      notion_updated_at: post.last_edited_time.to_datetime,
      notion_id: post.id,
      tags: get_tags(properties["Tag Names"]),
      category_id: get_category(properties["Category"]),
      status: get_status(properties.Status),
      content:,
    )

    if found_post.save
      puts "Post #{post.id} saved"
    else
      puts "Post #{post.id} not saved\n\n#{found_post.errors.full_messages}"
    end
  end

  def create_post(post)
    notion_converter = NotionToMd::Converter.new(page_id: post.id)
    content = notion_converter.convert
    properties = post.properties

    new_post = Post.create(
      notion_id: post.id,
      title: properties.Title.title.first.plain_text,
      description: get_description(properties.Description),
      published: properties.Published.checkbox,
      published_date: properties.Published.checkbox ? properties.Date.date.start : nil,
      notion_slug: properties.Slug&.rich_text&.first&.plain_text,
      notion_created_at: properties.Created.created_time.to_datetime,
      notion_updated_at: post.last_edited_time.to_datetime,
      tags: get_tags(properties["Tag Names"]),
      category_id: get_category(properties["Category"]),
      status: get_status(properties.Status),
      content:,
    )

    if new_post.save
      puts "Post #{post.id} saved"
    else
      puts "Post #{post.id} not saved\n\n#{new_post.errors.full_messages}"
    end
  end

  def get_status(status)
    {
      "Inbox" => "inbox",
      "Needs Refinement" => "needs_refinement",
      "Ready for Work" => "ready_for_work",
      "Outlining" => "outlining",
      "Drafting" => "drafting",
      "Editing" => "editing",
      "Published" => "published"
    }[status.status.name]
  end

  def get_category(category)
    return unless category.key?("relation")

    Category.find_by(notion_id: category.relation[0]&.id)&.id
  end

  def get_tags(tags)
    return unless tags.key?("rollup")
    return unless tags["rollup"].key?("array")

    tags["rollup"].array.map(&:title).flatten.map(&:plain_text)
  end

  def get_description(description)
    if description["rich_text"]&.any?
      description.rich_text.reduce("") { |desc, txt|  desc + txt.plain_text }
    else
      "-- Still need a description --"
    end
  end
end
