# frozen_string_literal: true

class PostFetcherJob < ApplicationJob
  queue_as :default

  def perform
    posts = NotionAdapter.fetch_posts

    return if posts.empty?

    binding.pry

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
    found_post && found_post.updated_at <= post[:notion_updated_at].to_date
  end

  def update_post(found_post, post)
    found_post.update!(
      content: post[:content],
      cover_image: get_cover_image(post[:cover_image]),
      description: post[:description],
      meta_description: post[:meta_description],
      notion_updated_at: post[:notion_updated_at],
      published: post[:published],
      published_date: post[:published_date],
      tags: post[:tags],
      title: post[:title],
      category_id: get_category_id(post[:category_notion_id])
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def create_post(post)
    Post.create!(
      content: post[:content],
      cover_image: get_cover_image(post[:cover_image]),
      description: post[:description],
      meta_description: post[:meta_description],
      notion_created_at: post[:notion_created_at],
      notion_updated_at: post[:notion_updated_at],
      published: post[:published],
      published_date: post[:published_date],
      tags: post[:tags],
      title: post[:title],
      notion_id: post[:notion_id],
      category_id: get_category_id(post[:category_notion_id])
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    puts e.message
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def get_category_id(category_notion_id)
    return unless category_notion_id

    Category.find_by(notion_id: category_notion_id)&.id
  end

  def get_cover_image(cover_image)
    return if cover_image.blank? || cover_image.empty? || cover_image.nil?
    return cover_image["external"]["url"] if cover_image["type"] == "external"

    return unless cover_image["type"] == "file"

    cover_image["file"]["url"]
  end
end
