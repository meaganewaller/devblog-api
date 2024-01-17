# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostFetcherJob, type: :job do
  let(:category) { create(:category) }

  describe '#perform' do
    it 'creates posts from Notion data', vcr: false do
      allow(NotionAdapter).to receive(:fetch_posts).and_return(
        [
          attributes_for(:post).merge(category_notion_id: category.notion_id),
          attributes_for(:post, :published).merge(category_notion_id: category.notion_id)
        ]
      )
      expect do
        described_class.perform_now
      end.to change { Post.count }.by(2)
    end

    it 'skips creation if no posts are fetched', vcr: false do
      allow(NotionAdapter).to receive(:fetch_posts).and_return([])

      expect { described_class.perform_now }.not_to(change { Post.count })
    end

    it 'updates posts if they already exist and if incoming data is newer', vcr: false do
      existing_post = create(:post, notion_id: 'post-id-1', title: 'Old Name', updated_at: 1.day.ago)
      allow(NotionAdapter).to receive(:fetch_posts).and_return(
        [
          attributes_for(
            :post,
            notion_id: 'post-id-1'
          ).merge(notion_updated_at: 1.hour.ago, category_notion_id: category.notion_id)
        ]
      )
      allow(NotionToMd::Converter).to receive(:new) {
        double(convert: 'Post converted')
      }
      expect do
        described_class.perform_now
      end.to(change { existing_post.reload.title })
    end

    it 'does not update posts if they already exist and if incoming data is older', vcr: false do
      existing_post = create(:post, notion_id: 'post-id-1', title: 'Old Name', notion_updated_at: 1.day.ago)
      allow(NotionAdapter).to receive(:fetch_posts).and_return(
        [
          attributes_for(:post, notion_id: 'post-id-1',
                                notion_updated_at: 2.days.ago)
        ]
      )
      allow(NotionToMd::Converter).to receive(:new) {
        double(convert: 'Post converted')
      }
      expect { described_class.perform_now }.not_to(change { existing_post.reload.title })
    end

    xit 'sets category from notion_id', vcr: false do
      allow(NotionAdapter).to receive(:fetch_posts).and_return(
        [
          attributes_for(:post, title: 'Post Title',
                                notion_id: 'post-id-1').merge(category_notion_id: existing_category.notion_id)
        ]
      )
      described_class.perform_now
      expect(existing_category.reload.posts.first.title).to eql 'Post Title'
    end
  end
end
