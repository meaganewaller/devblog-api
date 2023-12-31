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
require "rails_helper"

RSpec.describe Project, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:notion_id) }
    it { should validate_presence_of(:description) }
    it { should validate_inclusion_of(:difficulty_level).in_array(Project::ALLOWED_DIFFICULTY_LEVELS).allow_nil }
    it { should allow_value("https://github.com/example/repo").for(:repository_url) }
    it { should allow_value("https://example.com").for(:homepage_url) }
    it { should allow_value("https://example.com/documentation").for(:documentation_url) }

    describe "enums" do
      it {
        should define_enum_for(:status).with_values(%i[active archived deprecated completed on_hold beta alpha experimental
          abandoned merged under_development stable unmaintained feature_frozen])
      }
    end

    describe "#validate_demo_screenshot_urls" do
      it "validates demo_screenshot_urls" do
        project = build(:project, demo_screenshot_urls: ["http://example.com"])
        invalid_project = build(:project, demo_screenshot_urls: ["invalid"])

        expect(project).to be_valid
        expect(invalid_project).not_to be_valid
        expect(invalid_project.errors[:demo_screenshot_urls]).to include("contains an invalid URL: invalid")
      end
    end
  end
end
