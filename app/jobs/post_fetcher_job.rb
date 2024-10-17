# frozen_string_literal: true

# This job is responsible for kicking off the process of fetching posts from Notion.
class PostFetcherJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Fetching posts from Notion..."
    fetched_posts = NotionAdapter.fetch_posts

    return if fetched_posts.empty?

    Rails.logger.info "Fetched #{fetched_posts.count} posts from Notion."

    existing_posts = Post.where(notion_id: fetched_posts.map { |post| post[:notion_id] }).index_by(&:notion_id)

    Rails.logger.info "Existing posts: #{existing_posts.keys.join(", ")}"

    fetched_posts.each do |fetched_post|
      existing_post = existing_posts[fetched_post[:notion_id]] || nil
      Rails.logger.info "Processing post: #{fetched_post[:title]}"
      update_or_create_post(existing_post, fetched_post)
    end
  end

  private

  def update_or_create_post(existing_post, fetched_post)
    if existing_post && !skip?(existing_post, fetched_post)
      UpdatePostJob.perform_later(existing_post, fetched_post)
      # update_post(existing_post, fetched_post)
    elsif !existing_post
      CreatePostJob.perform_later(fetched_post)
      # create_post(fetched_post)
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
  rescue => e
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
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end
end
