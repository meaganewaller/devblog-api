# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                :uuid             not null, primary key
#  content           :text             not null
#  cover_image       :string
#  description       :text             not null
#  featured          :boolean          default(FALSE)
#  link              :string
#  notion_created_at :datetime         not null
#  notion_updated_at :datetime         not null
#  repository_links  :json
#  slug              :string           not null
#  tags              :text             default([]), is an Array
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notion_id         :string           not null
#
# Indexes
#
#  index_projects_on_notion_id  (notion_id) UNIQUE
#  index_projects_on_slug       (slug) UNIQUE
#  index_projects_on_tags       (tags) USING gin
#  index_projects_on_title      (title) UNIQUE
#
class Project < ApplicationRecord
  extend FriendlyId

  validates :title, presence: true, uniqueness: true
  validates :notion_id, presence: true, uniqueness: true
  validates :description, presence: true
  validates :content, presence: true

  validate :repository_links_are_valid_urls

  friendly_id :title, use: :slugged

  private

  def repository_links_are_valid_urls
    return if repository_links.blank?

    repository_links.each do |key, value|
      if key == 'url'
        uri = URI.parse(value)
        errors.add(:repository_links, "contains an invalid URL: #{value}") unless
        uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      end
    rescue URI::InvalidURIError
      errors.add(:repository_links, "contains an invalid URL: #{value}")
    end
  end
end
