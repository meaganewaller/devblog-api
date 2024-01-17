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
require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:notion_id) }
    it { should validate_presence_of(:description) }
  end

  describe "associations" do
    it { should have_many(:posts) }
  end

  describe "friendly_id" do
    it "should use title for slugged parameter" do
      category = create(:category)
      expect(category.slug).to eq(category.title.parameterize)
    end
  end
end
