# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  require "dotenv"
  Dotenv.load(".env")
  Dotenv.require_keys("PORT", "CLIENT_ORIGIN_URL", "NOTION_BLOG_DATABASE_ID", "NOTION_CATEGORY_DATABASE_ID",
    "NOTION_CONTACT_FORM_DATABASE_ID", "NOTION_TOKEN")
end
