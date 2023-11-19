# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                   :uuid             not null, primary key
#  contributors         :text             default([]), is an Array
#  creation_date        :date
#  demo_screenshot_urls :string           default([]), is an Array
#  description          :text             not null
#  difficulty_level     :string
#  documentation_url    :string
#  featured             :boolean          default(FALSE)
#  framework            :string
#  homepage_url         :string
#  language             :string
#  last_update          :date
#  license              :string
#  notion_created_at    :datetime         not null
#  notion_updated_at    :datetime         not null
#  open_issues          :integer          default(0)
#  pull_requests        :integer          default(0)
#  repository_url       :string
#  slug                 :string           not null
#  status               :integer          default("active")
#  tags                 :text             default([]), is an Array
#  title                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  notion_id            :string           not null
#
# Indexes
#
#  index_projects_on_featured  (featured)
#  index_projects_on_language  (language)
#  index_projects_on_slug      (slug) UNIQUE
#  index_projects_on_tags      (tags) USING gin
#  index_projects_on_title     (title) UNIQUE
#
class Project < ApplicationRecord
  extend FriendlyId
  ALLOWED_DIFFICULTY_LEVELS = %w[beginner intermediate advanced expert].freeze

  validates :title, presence: true, uniqueness: true
  validates :notion_id, presence: true, uniqueness: true
  validates :description, presence: true
  validates :difficulty_level, inclusion: {in: ALLOWED_DIFFICULTY_LEVELS, allow_nil: true}
  validates :repository_url, format: {with: URI::DEFAULT_PARSER.make_regexp},
    if: ->(project) { project.repository_url.present? }
  validates :homepage_url, format: {with: URI::DEFAULT_PARSER.make_regexp},
    if: ->(project) { project.homepage_url.present? }
  validates :documentation_url, format: {with: URI::DEFAULT_PARSER.make_regexp},
    if: ->(project) { project.documentation_url.present? }

  validate :validate_demo_screenshot_urls

  enum status: {
    active: 0, # Project is actively being developed, maintained, and updated.
    archived: 1, # Project is no longer actively maintained but is still available for reference
    deprecated: 2, # The project is outdated and no longer recommended for use or contribution
    completed: 3, # The project has been finished and is no longer being actively developed.
    on_hold: 4, # Development temporarily paused
    beta: 5, # Testing phase and may have limited features
    alpha: 6, # Early stage of development, limited functionality and potential instability
    experimental: 7, # Proof of concept or experimental and may not be fully functional
    abandoned: 8, # Development has been abandoned, and it's no longer being worked on
    merged: 9, # The project has been merged into another project or codebase
    under_development: 10, # Being actively worked on, but not yet ready for release
    stable: 11, # Stable and suitable for production use
    unmaintained: 12, # The project is not being actively maintained, and users should be cautious when using it
    feature_frozen: 13 # The project has reached a point where no new features will be added only bug fixes
  }

  friendly_id :title, use: :slugged

  private

  def validate_demo_screenshot_urls
    return if demo_screenshot_urls.blank?

    demo_screenshot_urls.each do |url|
      uri = URI.parse(url)
      errors.add(:demo_screenshot_urls, "contains an invalid URL: #{url}") unless
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      errors.add(:demo_screenshot_urls, "contains an invalid URL: #{url}")
    end
  end
end
