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
require 'rails_helper'

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

  describe "counter cache" do
    it "updates posts_count when posts are created" do
      category = create(:category)
      expect(category.posts_count).to eq(0)

      create(:post, category: category)
      category.reload
      expect(category.posts_count).to eq(1)
    end

    it "updates posts_count when posts are destroyed" do
      category = create(:category)
      post = create(:post, category: category)
      expect(category.posts_count).to eq(1)

      post.destroy
      category.reload
      expect(category.posts_count).to eq(0)
    end

    it "updates posts_count when posts are updated" do
      category = create(:category)
      post = create(:post, category: category)
      expect(category.posts_count).to eq(1)

      post.update(title: "Updated Title")
      category.reload
      expect(category.posts_count).to eq(1)
    end
  end
end
