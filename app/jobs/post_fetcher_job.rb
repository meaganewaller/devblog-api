# frozen_string_literal: true

class PostFetcherJob < ApplicationJob
  queue_as :default

  def perform
    posts = NotionAdapter.fetch_posts

    return if posts.empty?

    existing_posts = Post.where(notion_id: posts.map { |post| post[:notion_id] }).index_by(&:notion_id)

    posts.each do |post|
      found_post = existing_posts[post[:notion_id]]
      if skip?(found_post, post)
        Rails.logger.info("Skipping #{post[:title]} because it's already up to date")
        next
      end

      update_post(found_post, post) if found_post
      create_post(post)
    end
  end

  private

  def skip?(found_post, post)
    found_post && found_post.notion_updated_at >= post[:notion_updated_at].to_date
  end

  def update_post(found_post, post)
    found_post.update!(
      title: post[:title],
      description: post[:description],
      published: post[:published],
      published_date: post[:published_date],
      notion_created_at: post[:notion_created_at],
      notion_updated_at: post[:notion_updated_at],
      notion_id: post[:notion_id],
      tags: post[:tags],
      category_id: get_category_id(post[:category_notion_id]),
      content: post[:content]
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def create_post(post)
    Post.create!(
      notion_id: post[:notion_id],
      title: post[:title],
      description: post[:description],
      published: post[:published],
      published_date: post[:published_date],
      notion_created_at: post[:notion_created_at],
      notion_updated_at: post[:notion_updated_at],
      tags: post[:tags],
      category_id: get_category_id(post[:category_notion_id]),
      content: post[:content],
      # cover_image: get_cover_image(post[:cover_image]),
      meta_description: post[:meta_description],
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def get_category_id(category_notion_id)
    return unless category_notion_id

    Category.find_by(notion_id: category_notion_id)&.id
  end

  def get_cover_image(cover_image)
    return unless cover_image.blank?
    return cover_image["file"]["url"] if cover_image.key?("file")

    cover_image["external"]["url"]
  end
end
