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
class Talk < ApplicationRecord
  extend FriendlyId
  belongs_to :category, inverse_of: :talks, optional: true

  validates :description, presence: true
  validates :notion_created_at, presence: true
  validates :notion_updated_at, presence: true
  validates :title, presence: true
  validates :notion_id, presence: true, uniqueness: true
  validates :content, presence: true

  has_many :views, as: :viewable, foreign_key: :viewable_slug
  has_one_attached :image

  default_scope { order(date: :desc) }
  scope :filter_by_category, -> (category) { joins(:category).where("lower(categories.slug) = ?", category.downcase)}
  scope :filter_by_tag, -> (tag) { where("LOWER(?) = ANY (SELECT LOWER(unnest(tags)))", tag.downcase) }

  friendly_id :title, use: :slugged

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
end
