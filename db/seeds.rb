# frozen_string_literal: true

require 'faker'

Category.delete_all
GuestbookEntry.delete_all
View.delete_all
Post.delete_all

GoodJob::Batch.enqueue(on_finish: PostFetcherJob) do
  CategoryFetcherJob.perform_now
end
