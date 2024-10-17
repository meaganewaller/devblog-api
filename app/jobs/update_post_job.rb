# frozen_string_literal: true

# This job is responsible for updating an existing post from the Notion API
class UpdatePostJob < BasePostJob
  def perform(existing_post, updated_post)
    Rails.logger.info("Updating post: #{existing_post.title}")
    existing_post.update!(post_params(updated_post))
    if get_cover_image(updated_post[:cover_image])
      StorePostImageJob.perform_later(existing_post, get_cover_image(updated_post[:cover_image]))
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end
end
