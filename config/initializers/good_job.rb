# frozen_string_literal: true

Rails.application.configure do
  config.good_job.on_thread_error = ->(exception) { Raven.capture_exception(exception) }
  config.good_job.preserve_job_records = true
  config.good_job.retry_on_unhandled_error = false
  config.good_job.cleanup_interval_seconds = 600
  config.good_job.cleanup_interval_jobs = 20

  if Rails.env.production?
    config.good_job.execution_mode = :async
    config.good_job.cron = {
      fetch_all_posts: {
        cron: '0 0 * * *',
        class: 'PostFetcherJob',
        description: 'Fetch all posts from Notion blog database'
      },
      fetch_all_categories: {
        cron: '0 0 1 * *',
        class: 'CategoryFetcherJob',
        description: 'Fetch all categories from Notion category database'
      }
    }

    GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
      return false if username.blank? || password.blank?

      ActiveSupport::SecurityUtils.secure_compare(Rails.application.credentials.good_job_username, username) &&
        ActiveSupport::SecurityUtils.secure_compare(Rails.application.credentials.good_job_password, password)
    end
  end
end
