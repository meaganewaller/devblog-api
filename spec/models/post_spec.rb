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
#  notion_created_at :datetime
#  notion_updated_at :datetime
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
#  index_posts_on_category_id        (category_id)
#  index_posts_on_notion_created_at  (notion_created_at)
#  index_posts_on_notion_id          (notion_id) UNIQUE
#  index_posts_on_notion_updated_at  (notion_updated_at)
#  index_posts_on_published          (published)
#  index_posts_on_searchable         (searchable) USING gin
#  index_posts_on_slug               (slug) UNIQUE
#  index_posts_on_tags               (tags) USING gin
#  index_posts_on_title              (title) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:notion_created_at) }
    it { should validate_presence_of(:notion_updated_at) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:notion_id) }
  end

  describe 'associations' do
    it { should belong_to(:category).inverse_of(:posts).optional }
  end

  describe 'scopes' do
    let!(:published_post) { create(:post, :published) }

    it '.published should return only published posts' do
      expect(Post.published).to eq([published_post])
    end
  end
end
