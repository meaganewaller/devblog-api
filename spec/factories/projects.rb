# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                :uuid             not null, primary key
#  content           :text             not null
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
FactoryBot.define do
  factory :project do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    difficulty_level { Project::ALLOWED_DIFFICULTY_LEVELS.sample }
    notion_id { SecureRandom.uuid }
  end
end
