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
require "rails_helper"

RSpec.describe Post, type: :model do
  describe "validations" do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:notion_created_at) }
    it { should validate_presence_of(:notion_updated_at) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:notion_id) }
    it { should validate_presence_of(:notion_slug) }

    it "validates notion_slug case-sensitively uniqueness" do
      existing_post = create(:post)
      new_post = build(:post, notion_slug: existing_post.notion_slug)

      expect(new_post).not_to be_valid
      expect(new_post.errors[:notion_slug]).to include("has already been taken")
    end
  end

  describe "associations" do
    it { should belong_to(:category).inverse_of(:posts).optional }
    it { should have_many(:reactions).dependent(:destroy).inverse_of(:post) }
  end

  describe "enums" do
    it {
      should define_enum_for(:status).with_values(inbox: 0, needs_refinement: 1, ready_for_work: 2, outlining: 3,
        drafting: 4, editing: 5, done: 6)
    }
  end

  describe "scopes" do
    let!(:published_post) { create(:post, published: true) }
    let!(:drafting_post) { create(:post, status: "drafting") }
    let!(:needs_refinement_post) { create(:post, status: "needs_refinement") }

    it ".published should return only published posts" do
      expect(Post.published).to eq([published_post])
    end

    it ".drafting should return posts with status 'drafting'" do
      expect(Post.drafting).to eq([drafting_post])
    end

    it ".needs_refinement should return posts with status 'needs_refinement'" do
      expect(Post.needs_refinement).to eq([needs_refinement_post])
    end
  end

  describe "friendly_id" do
    it "should use notion_slug for slugged parameter" do
      post = create(:post)
      expect(post.slug).to eq(post.notion_slug.parameterize)
    end
  end
end
