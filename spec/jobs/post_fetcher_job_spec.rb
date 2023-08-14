require 'rails_helper'

RSpec.describe PostFetcherJob, type: :job do
  describe "#perform" do
    it "creates posts from Notion data" do
      allow(NotionAdapter).to receive(:fetch_posts).and_return(
        [
          attributes_for(:post),
          attributes_for(:post, :published),
        ]
      )
      allow(NotionToMd::Converter).to receive(:new) {
        double(convert: "Post converted")
      }
      expect {
        described_class.perform_now
      }.to change { Post.count }.by(2)
    end

    it "skips creation if no posts are fetched" do
      allow(NotionAdapter).to receive(:fetch_posts).and_return([])

      expect { described_class.perform_now }.not_to change { Post.count }
    end

    it "updates posts if they already exist and if incoming data is newer" do
      existing_post = create(:post, notion_id: "post-id-1", title: "Old Name", notion_updated_at: 1.day.ago)
      allow(NotionAdapter).to receive(:fetch_posts).and_return([
        attributes_for(:post, notion_id: "post-id-1", notion_updated_at: 1.hour.ago)
      ])
      allow(NotionToMd::Converter).to receive(:new) {
        double(convert: "Post converted")
      }
      expect {
        described_class.perform_now
      }.to change { existing_post.reload.title }
    end

    it "does not update posts if they already exist and if incoming data is older" do
      existing_post = create(:post, notion_id: "post-id-1", title: "Old Name", notion_updated_at: 1.day.ago)
      allow(NotionAdapter).to receive(:fetch_posts).and_return([
        attributes_for(:post, notion_id: "post-id-1", notion_updated_at: 2.days.ago)
      ])
      allow(NotionToMd::Converter).to receive(:new) {
        double(convert: "Post converted")
      }
      expect { described_class.perform_now }.not_to change { existing_post.reload.title }
    end

    it "sets category from notion_id" do
      existing_category = create(:category, notion_id: Faker::Internet.uuid)
      allow(NotionAdapter).to receive(:fetch_posts).and_return([
        attributes_for(:post, title: "Post Title", notion_id: "post-id-1").merge(category_notion_id: existing_category.notion_id)
      ])
      allow(NotionToMd::Converter).to receive(:new) {
        double(convert: "Post converted")
      }
      expect {
        described_class.perform_now
      }.to change { existing_category.posts.count }.by(1)
      expect(existing_category.reload.posts_count).to eql 1
      expect(existing_category.posts.first.title).to eql "Post Title"
    end

  end
end
