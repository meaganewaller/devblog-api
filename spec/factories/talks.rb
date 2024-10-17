# == Schema Information
#
# Table name: talks
#
#  id                :uuid             not null, primary key
#  comment_count     :integer          default(0), not null
#  content           :text             not null
#  cover_image       :string
#  date              :date
#  description       :string           not null
#  meta_description  :string
#  notion_created_at :datetime
#  notion_updated_at :datetime
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
#  index_talks_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
FactoryBot.define do
  factory :talk do
    sequence(:title) { |n| Faker::Lorem.sentence(random_words_to_add: 4) + n.to_s }
    description { Faker::Lorem.paragraph }
    date { Faker::Date.backward(days: 14) }
    notion_created_at { Faker::Date.backward(days: 30) }
    notion_updated_at { Faker::Date.backward(days: 29) }
    notion_id { Faker::Internet.uuid }
    content { Faker::Markdown.sandwich(sentences: 5) }

    association :category
    meta_description { Faker::Lorem.sentence }
    cover_image { Faker::File.file_name(ext: 'png') }
    comment_count { Faker::Number.between(from: 1, to: 1000) }
  end
end
