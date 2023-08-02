# == Schema Information
#
# Table name: posts
#
#  id                :uuid             not null, primary key
#  category          :string
#  content           :text
#  description       :string           not null
#  language          :string
#  notion_created_at :date             not null
#  notion_slug       :string           not null
#  notion_updated_at :date             not null
#  published         :boolean          default(FALSE), not null
#  published_date    :date
#  slug              :string           not null
#  tags              :string           default([]), is an Array
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notion_id         :string           not null
#
# Indexes
#
#  index_posts_on_notion_slug  (notion_slug) UNIQUE
#  index_posts_on_published    (published)
#  index_posts_on_slug         (slug) UNIQUE
#  index_posts_on_tags         (tags) USING gin
#
FactoryBot.define do
  factory :post do
    trait :published do
      published { true }
    end

    trait :draft do
      published { false }
    end

    trait :in_the_future do
      published_date { 2.days.from_now }
    end

    trait :in_the_past do
      published_date { 2.days.ago }
    end

    trait :with_reactions do
      after :create do |post|
        create_list :reaction, 3, post: post
      end
    end

    title { Faker::Lorem.sentence }
    notion_id { Faker::Internet.uuid }
    description { Faker::Lorem.paragraph }
    notion_slug { Faker::Internet.slug }
    slug { Faker::Internet.slug }
    notion_created_at { Faker::Date.backward(days: 14) }
    notion_updated_at { Faker::Date.backward(days: 14) }
    tags { Faker::Lorem.words.split(" ") }
    content { Faker::Markdown.sandwich(sentences: 5) }
  end
end
