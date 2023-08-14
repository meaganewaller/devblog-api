# == Schema Information
#
# Table name: posts
#
#  id                :uuid             not null, primary key
#  content           :text
#  description       :string           not null
#  language          :string
#  notion_created_at :date             not null
#  notion_slug       :string           not null
#  notion_updated_at :date             not null
#  published         :boolean          default(FALSE), not null
#  published_date    :date
#  slug              :string           not null
#  status            :integer          default("inbox")
#  tags              :string           default([]), is an Array
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  category_id       :uuid
#  notion_id         :string           not null
#
# Indexes
#
#  index_posts_on_category_id  (category_id)
#  index_posts_on_notion_id    (notion_id)
#  index_posts_on_notion_slug  (notion_slug) UNIQUE
#  index_posts_on_published    (published)
#  index_posts_on_slug         (slug) UNIQUE
#  index_posts_on_tags         (tags) USING gin
#

FactoryBot.define do
  factory :post do
    sequence(:title) { |n| Faker::Lorem.sentence(random_words_to_add: 4) + n.to_s }
    notion_id   { Faker::Internet.uuid }
    description { Faker::Lorem.paragraph }
    sequence(:notion_slug) { |n| "#{Faker::Internet.slug}-#{n}" }
    notion_created_at { Faker::Date.backward(days: 14) }
    notion_updated_at { Faker::Date.backward(days: 14) }
    tags { Faker::Lorem.words(number: 3) }
    content { Faker::Markdown.sandwich(sentences: 5) }
    published { false }
    status { "inbox" }

    # Association with a category
    association :category

    trait :drafting do
      status { "drafting" }
    end

    trait :published do
      published { true }
      published_date { Date.today }
      status { "published" }
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


    factory :drafting_post, traits: [:drafting]
    factory :published_post, traits: [:published]
  end
end
