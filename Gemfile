source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "active_model_serializers"
gem "activerecord-postgresql-adapter"
gem "bleib", "~> 0.0"
gem "good_job", "~> 3.15"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.6", require: false

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jb", "~> 0.8"
gem "jwt", "~> 2.7", require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.12", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

gem "rails-healthcheck", "~> 1.4"
gem "silencer", "~> 2.0", require: false

gem "friendly_id", "~> 5.5"
gem "nanoid", "~> 2.0"
gem "fast_blank", platform: :mri
gem "polist", "~> 1.4", require: false
gem "dotenv", "~> 2.8", groups: [:development, :test]
gem "dotenv-rails", "~> 2.8", groups: [:development, :test]

gem "notion-ruby-client", "~> 1.1", require: false
gem "notion_to_md"
gem "hashdiff", "~> 1.0", require: false

gem "pagy", "~> 5.0"
gem 'counter_culture', '~> 3.2'
gem 'pg_search', "~> 2.3"

group :development, :test do
  gem "amazing_print", "~> 1.5", require: false
  gem "annotate"
  gem "awesome_rails_console", "~> 0.4"
  gem "database_cleaner", "~> 2.0", require: false
  gem "debug", "~> 1.8", platforms: %i[mri mingw x64_mingw], require: false
  gem "factory_bot", "~> 6.2"
  gem "factory_bot_rails", "~> 6.2"
  gem "factory_trace", "~> 1.0", require: false
  gem "faker", "~> 3.2.1"
  gem "isolator", "~> 0.9"
  gem "parallel", "~> 1.23"
  gem "parallel_tests", "~> 4.2"
  gem "pry-byebug"
  gem "pry-doc", require: false
  gem "pry-rails", "~> 0.3"
  gem "pry-rescue", "~> 1.5"
  gem "pry-stack_explorer", require: false
  gem "rerun", "~> 0.14", require: false
  gem "rspec-rails"
  gem "ruby-prof", ">= 0.16.0", require: false
  gem "shoulda-matchers", "~> 5.3", require: false
  gem "stackprof", ">= 0.2.9", require: false
  gem "vcr"
end

group :development do
  gem "brakeman", require: false
  gem "bullet", "~> 7.0"
  gem "bundler-audit", require: false
  gem "database_consistency", require: false
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem "fasterer"
  gem "listen", "~> 3.8", require: false
  gem "ordinare", require: false
  gem "overcommit", "~> 0.60", require: false
  gem "rack-mini-profiler", "~> 3.1"
  gem "rubocop-performance", "~> 1.15", require: false
  gem "rubocop-rspec"
  gem "standard", "~> 1.22"
  gem "standard-rails", "~> 0.1", require: false
  gem "strong_migrations", "~> 1.4"
  gem "timecop"
end

group :test do
  gem "consistency_fail", "~> 0.3", require: false
  gem "database_rewinder", "~> 0.9"
  gem "fuubar", "~> 2.5", require: false
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  gem "test-prof"
  gem "webmock", "~> 3.18", require: false
  gem "zonebie"
end

group :console do
  gem "gem_bench"
end
