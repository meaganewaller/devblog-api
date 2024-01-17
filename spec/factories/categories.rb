# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id          :uuid             not null, primary key
#  cover_image :string
#  description :string           not null
#  slug        :string           not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  notion_id   :string           not null
#
# Indexes
#
#  index_categories_on_notion_id  (notion_id) UNIQUE
#  index_categories_on_slug       (slug) UNIQUE
#  index_categories_on_title      (title) UNIQUE
#
FactoryBot.define do
  factory :category do
    title { Faker::Lorem.sentences(number: 1) }
    description { Faker::Lorem.sentences(number: 3) }
    notion_id { Faker::Internet.uuid }
  end
end
