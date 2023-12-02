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
#  notion_created_at :date             not null
#  notion_updated_at :date             not null
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
#  index_posts_on_category_id  (category_id)
#  index_posts_on_notion_id    (notion_id) UNIQUE
#  index_posts_on_published    (published)
#  index_posts_on_searchable   (searchable) USING gin
#  index_posts_on_slug         (slug) UNIQUE
#  index_posts_on_tags         (tags) USING gin
#  index_posts_on_title        (title) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
class Post < ApplicationRecord
  extend FriendlyId
  include PgSearch::Model

  belongs_to :category, inverse_of: :posts, optional: true

  validates :description, presence: true
  validates :notion_created_at, presence: true
  validates :notion_updated_at, presence: true
  validates :title, presence: true
  validates :notion_id, presence: true, uniqueness: true

  has_many :reactions, dependent: :destroy, inverse_of: :post
  has_many :views, as: :viewable, foreign_key: :viewable_slug

  pg_search_scope :search_post, against: {
    title: "A",
    description: "B",
    content: "C"
  }, using: {tsearch: {dictionary: "english", tsvector_column: "searchable"}}

  default_scope { order(published_date: :desc) }
  scope :filter_by_category, ->(category) { joins(:category).where("lower(categories.slug) = ?", category.downcase) }
  scope :filter_by_tag, ->(tag) { where("LOWER(?) = ANY (SELECT LOWER(unnest(tags)))", tag.downcase) }

  scope :published, -> { where(published: true) }

  friendly_id :title, use: :slugged
end
