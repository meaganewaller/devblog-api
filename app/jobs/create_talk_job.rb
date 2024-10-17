# frozen_string_literal: true

# This job is responsible for creating a new talk from the Notion API
class CreateTalkJob < BaseTalkJob
  queue_as :default

  def perform(talk)
    Rails.logger.info("Creating new talk: #{talk[:title]}")
    new_talk = Talk.new(talk_params(talk))
    new_talk.save!

    if get_cover_image(talk[:cover_image])
      StoreTalkImageJob.perform_later(new_talk, get_cover_image(talk[:cover_image]))
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during creation: #{e.message}")
  end
end

