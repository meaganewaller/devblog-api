# frozen_string_literal: true

# This job is responsible for creating a new post from the Notion API
class CreatePostJob < BasePostJob
  queue_as :default

  def perform(post)
    Rails.logger.info("Creating new post: #{post[:title]}")
    new_post = Post.new(post_params(post))
    new_post.save!

    if get_cover_image(post[:cover_image])
      StorePostImageJob.perform_later(new_post, get_cover_image(post[:cover_image]))
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during creation: #{e.message}")
  end
end
