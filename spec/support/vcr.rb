# frozen_string_literal: true

require "vcr"
require "webmock/rspec"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/notion"
  config.hook_into :webmock
  # config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
  config.before_record do |i|
    i.request.headers["Authorization"].first.gsub!(ENV["NOTION_TOKEN"], "<NOTION_TOKEN>") if ENV.key?("NOTION_TOKEN")
    i.response.body.force_encoding("UTF-8")
  end
end
