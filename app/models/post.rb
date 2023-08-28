# == Schema Information
#
# Table name: posts
#
#  id                :uuid             not null, primary key
#  content           :text
#  cover_image       :string
#  description       :string           not null
#  language          :string
#  meta_description  :string
#  meta_keywords     :text             default([]), is an Array
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
class Post < ApplicationRecord
  extend FriendlyId

  belongs_to :category, inverse_of: :posts, required: false

  validates :description, presence: true
  validates :notion_created_at, presence: true
  validates :notion_updated_at, presence: true
  validates :title, presence: true
  validates :notion_id, presence: true, uniqueness: true
  validates :notion_slug, presence: true, uniqueness: true
  enum :status, {
    inbox: 0,
    needs_refinement: 1,
    ready_for_work: 2,
    outlining: 3,
    drafting: 4,
    editing: 5,
    published: 6
  }

  has_many :reactions, dependent: :destroy, inverse_of: :post
  scope :filter_by_category, -> (category) { joins(:category).where(categories: { slug: category }) }
  scope :filter_by_tag, -> (tag) { where('? = ANY (tags)', tag) }

  scope :published, -> { where(published: true) }
  scope :drafting, -> { where(status: 4) }
  scope :needs_refinement, -> { where(status: 1) }
  scope :ready_for_work, -> { where(status: 2) }
  scope :outlining, -> { where(status: 3) }
  scope :drafting, -> { where(status: 4) }
  scope :editing, -> { where(status: 5) }

  friendly_id :notion_slug, use: :slugged

end
