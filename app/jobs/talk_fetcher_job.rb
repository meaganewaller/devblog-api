# frozen_string_literal: true

# This job is responsible for kicking off the process of fetching talks from Notion.
class TalkFetcherJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Fetching talks from Notion..."
    fetched_talks = NotionAdapter.fetch_talks

    return if fetched_talks.empty?

    Rails.logger.info "Fetched #{fetched_talks.count} talks from Notion."

    existing_talks = Talk.where(notion_id: fetched_talks.map { |talk| talk[:notion_id] }).index_by(&:notion_id)

    Rails.logger.info "Existing talks: #{existing_talks.keys.join(", ")}"

    fetched_talks.each do |fetched_talk|
      existing_talk = existing_talks[fetched_talk[:notion_id]] || nil
      Rails.logger.info "Processing talk: #{fetched_talk[:title]}"
      update_or_create_talk(existing_talk, fetched_talk)
    end
  end

  private

  def update_or_create_talk(existing_talk, fetched_talk)
    if existing_talk && !skip?(existing_talk, fetched_talk)
      UpdateTalkJob.perform_later(existing_talk, fetched_talk)
      # update_talk(existing_talk, fetched_talk)
    elsif !existing_talk
      CreateTalkJob.perform_later(fetched_talk)
      # create_talk(fetched_talk)
    end
  end

  def skip?(existing_talk, fetched_talk)
    existing_talk &&
      (existing_talk&.notion_updated_at&.>= fetched_talk[:notion_updated_at].to_datetime)
  end

  def update_talk(existing_talk, fetched_talk)
    Rails.logger.info("Updating talk: #{existing_talk.title}")
    existing_talk.update!(talk_params(fetched_talk))
    if get_cover_image(fetched_talk[:cover_image])
      StoreTalkImageJob.perform_later(existing_talk, get_cover_image(fetched_talk[:cover_image]))
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def create_talk(talk)
    Rails.logger.info("Creating new talk: #{talk[:title]}")
    new_talk = Talk.new(talk_params(talk))
    new_talk.save!
    if get_cover_image(talk[:cover_image])
      StoreTalkImageJob.perform_later(new_talk, get_cover_image(talk[:cover_image]))
    end
  rescue ActiveRecord::RecordInvalid => e
    puts e.message
    Rails.logger.error("Validation error: #{e.message}")
  rescue => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end
end

