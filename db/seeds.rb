# frozen_string_literal: true

require "faker"

Talk.delete_all
Post.delete_all
Category.delete_all
GuestbookEntry.delete_all
View.delete_all

GoodJob::Batch.enqueue(on_finish: RecordFetcherJob) do
  CategoryFetcherJob.perform_now
end

