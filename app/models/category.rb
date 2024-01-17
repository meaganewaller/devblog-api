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
class Category < ApplicationRecord
  extend FriendlyId
  has_many :posts

  validates :title, presence: true
  validates :notion_id, presence: true
  validates :description, presence: true

  friendly_id :title, use: :slugged

  scope :with_published_posts, -> { joins(:posts).where(posts: { published: true }).distinct }
end
