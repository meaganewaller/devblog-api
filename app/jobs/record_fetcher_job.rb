# frozen_string_literal: true

# This job is responsible for kicking off the processing of fetching all records from Notion.
class RecordFetcherJob < ApplicationJob
  queue_as :default

  def perform(batch, context)
    Rails.logger.info "Fetching records from Notion..."
    if context[:event] == :success
      GoodJob::Bulk.enqueue([PostFetcherJob.new, TalkFetcherJob.new])
    end
  end
end
