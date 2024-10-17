# frozen_string_literal: true

# This job is responsible for updating an existing talk from the Notion API
class UpdateTalkJob < BaseTalkJob
  def perform(existing_talk, updated_talk)
    Rails.logger.info("Updating talk: #{existing_talk.title}")
    existing_talk.update!(talk_params(updated_talk))
    if get_cover_image(updated_talk[:cover_image])
      StoreTalkImageJob.perform_later(existing_talk, get_cover_image(updated_talk[:cover_image]))
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end
end

