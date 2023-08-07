# == Schema Information
#
# Table name: categories
#
#  id          :uuid             not null, primary key
#  description :string
#  posts_count :integer
#  slug        :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  notion_id   :string
#
# Indexes
#
#  index_categories_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :category do
    title { "MyString" }
    description { "MyString" }
    post_count { 1 }
  end
end
