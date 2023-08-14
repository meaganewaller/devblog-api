source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "active_model_serializers"
gem "activerecord-postgresql-adapter"
gem "bleib", "0.0.8"
gem "good_job"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jb"
gem "jwt"
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

gem "rails-healthcheck"
gem "silencer", "~> 2.0", require: false

gem "friendly_id", "~> 5.5"
gem "nanoid", "~> 2.0"
gem "blueprinter"
gem "fast_blank", platform: :mri
# gem "knock_knock"
gem "oj"
gem "polist"
gem "dotenv-rails", groups: [:development, :test]

gem "notion-ruby-client", "~> 1.1.0"
gem "notion_to_md"
gem "hashdiff"
gem "amazing_print", group: [:development, :test]
gem "pagy", "~> 5.0"
gem 'counter_culture', '~> 3.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "annotate"
  gem "database_cleaner"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "factory_trace"
  gem "hirb"
  gem "hirb-unicode-steakknife", require: "hirb-unicode"
  gem "isolator"
  gem "parallel_tests"
  gem "faker"
  gem "pry-byebug"
  gem "pry-rails"
  gem "pry-rescue"
  gem "pry-doc", require: false
  gem "pry-stack_explorer", require: false
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "awesome_rails_console"
  gem "ruby-prof", ">= 0.16.0", require: false
  gem "stackprof", ">= 0.2.9", require: false
end

group :development do
  gem "database_consistency", require: false
  gem "brakeman", require: false
  gem "bullet"
  gem "bundler-audit", require: false
  gem "listen"
  gem "ordinare", require: false
  gem "strong_migrations"
  gem "fasterer"
  gem "overcommit"
  gem "standard", ">= 1.0.0"
  gem "rubocop-config-prettier"
  gem "rubocop-performance"
  gem "standard-rails"
  gem "rubocop-rspec"
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem "rack-mini-profiler"
end

group :test do
  gem "consistency_fail"
  gem "database_rewinder"
  gem "fuubar"
  gem "bundle-audit"
  gem "simplecov"
  gem "simplecov-console"
  gem "test-prof"
  gem "webmock"
  gem "zonebie"
end
