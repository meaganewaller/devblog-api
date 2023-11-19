# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoryFetcherJob, type: :job do
  describe "#perform" do
    it "creates categories from Notion data" do
      allow(NotionAdapter).to receive(:fetch_categories).and_return([
        attributes_for(:category),
        attributes_for(:category)
      ])
      expect { described_class.perform_now }.to change { Category.count }.by(2)
    end

    it "skips creation if no categories are fetched" do
      allow(NotionAdapter).to receive(:fetch_categories).and_return([])
      expect { described_class.perform_now }.not_to(change { Category.count })
    end

    it "updates categories if they already exist and if incoming data is newer" do
      existing_category = create(:category, notion_id: "category-id-1", title: "Old Name", updated_at: 1.day.ago)
      allow(NotionAdapter).to receive(:fetch_categories).and_return([
        attributes_for(:category,
          notion_id: "category-id-1").merge(last_edited_time: 1.hour.ago)
      ])
      expect do
        described_class.perform_now
      end.to(change { existing_category.reload.title })
    end

    it "does not update categories if they already exist and if incoming data is older" do
      existing_category = create(:category, notion_id: "category-id-1", title: "Old Name", updated_at: 1.day.ago)
      allow(NotionAdapter).to receive(:fetch_categories).and_return([
        attributes_for(:category,
          notion_id: "category-id-1").merge(last_edited_time: 2.days.ago)
      ])
      expect { described_class.perform_now }.not_to(change { existing_category.reload.title })
    end
  end
end
