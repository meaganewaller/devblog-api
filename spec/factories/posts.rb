# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id                :uuid             not null, primary key
#  comment_count     :integer          default(0), not null
#  content           :text             not null
#  cover_image       :string
#  description       :string           not null
#  meta_description  :string
#  notion_created_at :datetime
#  notion_updated_at :datetime
#  published         :boolean          default(FALSE), not null
#  published_date    :date
#  searchable        :tsvector
#  slug              :string           not null
#  tags              :string           default([]), is an Array
#  title             :string           not null
#  views_count       :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  category_id       :uuid             not null
#  notion_id         :string           not null
#
# Indexes
#
#  index_posts_on_category_id        (category_id)
#  index_posts_on_notion_created_at  (notion_created_at)
#  index_posts_on_notion_id          (notion_id) UNIQUE
#  index_posts_on_notion_updated_at  (notion_updated_at)
#  index_posts_on_published          (published)
#  index_posts_on_searchable         (searchable) USING gin
#  index_posts_on_slug               (slug) UNIQUE
#  index_posts_on_tags               (tags) USING gin
#  index_posts_on_title              (title) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#

FactoryBot.define do
  factory :post do
    sequence(:title) { |n| Faker::Lorem.sentence(random_words_to_add: 4) + n.to_s }
    notion_id { Faker::Internet.uuid }
    description { Faker::Lorem.paragraph }
    notion_created_at { Faker::Date.backward(days: 14) }
    notion_updated_at { Faker::Date.backward(days: 14) }
    # tags { Faker::Lorem.words(number: 3) }
    content { Faker::Markdown.sandwich(sentences: 5) }
    published { false }

    # Association with a category
    association :category

    trait :published do
      published { true }
      published_date { Faker::Date.backward(days: 14) }
    end
  end
end
