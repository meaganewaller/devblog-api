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
#  index_categories_on_slug  (slug) UNIQUE
#
class Category < ApplicationRecord
  extend FriendlyId
  has_many :posts

  validates :title, presence: true
  validates :notion_id, presence: true
  validates :description, presence: true

  friendly_id :title, use: :slugged

  scope :with_published_posts, -> { joins(:posts).where(posts: { published: true }).distinct }

  def update_posts_count
    published_posts_count = posts.published.count
    self.posts_count = published_posts_count
    self.save
  end
end
