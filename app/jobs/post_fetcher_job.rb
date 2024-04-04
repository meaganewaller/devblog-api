# frozen_string_literal: true

# This job is responsible for kicking off the process of fetching posts from Notion.
class PostFetcherJob < ApplicationJob
  queue_as :default

  def perform
    fetched_posts = NotionAdapter.fetch_posts

    return if fetched_posts.empty?

    existing_posts = Post.where(notion_id: fetched_posts.map { |post| post[:notion_id] }).index_by(&:notion_id)

    fetched_posts.each do |fetched_post|
      existing_post = existing_posts[fetched_post[:notion_id]] || nil
      update_or_create_post(existing_post, fetched_post)
    end

    Rails.logger.info "Fetched #{fetched_posts.count} posts from Notion."
  end

  private

  def update_or_create_post(existing_post, fetched_post)
    if existing_post && !skip?(existing_post, fetched_post)
      update_post(existing_post, fetched_post)
    elsif !existing_post
      create_post(fetched_post)
    end
  end

  def skip?(existing_post, fetched_post)
    existing_post &&
      (existing_post&.notion_updated_at&.>= fetched_post[:notion_updated_at].to_datetime)
  end

  def update_post(existing_post, fetched_post)
    Rails.logger.info("Updating post: #{existing_post.title}")
    existing_post.update!(post_params(fetched_post))
    if get_cover_image(fetched_post[:cover_image])
      StorePostImageJob.perform_later(existing_post, get_cover_image(fetched_post[:cover_image]))
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def create_post(post)
    Rails.logger.info("Creating new post: #{post[:title]}")
    new_post = Post.new(post_params(post))
    new_post.save!
    if get_cover_image(post[:cover_image])
      StorePostImageJob.perform_later(new_post, get_cover_image(post[:cover_image]))
    end
  rescue ActiveRecord::RecordInvalid => e
    puts e.message
    Rails.logger.error("Validation error: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  # rubocop:disable Metrics/MethodLength
  def post_params(post)
    {
      content: post[:content],
      category_id: get_category_id(post[:category_notion_id]),
      description: post[:description],
      meta_description: post[:meta_description],
      notion_created_at: post[:notion_created_at],
      notion_id: post[:notion_id],
      notion_updated_at: post[:notion_updated_at],
      published: post[:published],
      published_date: post[:published_date],
      tags: post[:tags],
      title: post[:title]
    }
  end
  # rubocop:enable Metrics/MethodLength

  def get_cover_image(cover_image)
    return if cover_image.blank? || cover_image.empty? || cover_image.nil?
    return cover_image['external']['url'] if cover_image['type'] == 'external'

    return unless cover_image['type'] == 'file'

    cover_image['file']['url']
  end

  def get_category_id(category_notion_id)
    Category.find_by(notion_id: category_notion_id)&.id
  end
end
