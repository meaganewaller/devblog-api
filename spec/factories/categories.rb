# == Schema Information
#
# Table name: categories
#
#  id          :uuid             not null, primary key
#  description :string
#  slug        :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  notion_id   :string
#
# Indexes
#
#  index_categories_on_notion_id  (notion_id)
#  index_categories_on_slug       (slug) UNIQUE
#
FactoryBot.define do
  factory :category do
    title { Faker::Lorem.sentences(number: 1) }
    description { Faker::Lorem.sentences(number: 3) }
    notion_id { Faker::Internet.uuid }
  end
end
