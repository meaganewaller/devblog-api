require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load dotenv only in development or test environment
if ['development', 'test'].include? ENV['RAILS_ENV']
  Dotenv::Railtie.load
end

module Blog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.eager_load_paths << Rails.root.join("app", "services")
    config.eager_load_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("lib", "notion", "api", "endpoints")

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.active_record.verify_foreign_keys_for_fixtures = false
    config.active_record.partial_inserts = true
    config.active_record.schema_format = :sql

    config.i18n.default_locale = :en
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = :local



  end
end
