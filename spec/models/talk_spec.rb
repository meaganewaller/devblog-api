# == Schema Information
#
# Table name: talks
#
#  id                :uuid             not null, primary key
#  comment_count     :integer          default(0), not null
#  content           :text             not null
#  cover_image       :string
#  date              :date
#  description       :string           not null
#  meta_description  :string
#  notion_created_at :datetime
#  notion_updated_at :datetime
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
#  index_talks_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
require 'rails_helper'

RSpec.describe Talk, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:notion_created_at) }
    it { is_expected.to validate_presence_of(:notion_updated_at) }
    it { is_expected.to validate_presence_of(:notion_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:category).inverse_of(:talks).optional }
  end

  describe "scopes" do
    let(:category) { create(:category) }
    let(:category2) { create(:category) }
    let(:category3) { create(:category) }

    let!(:talk) { create(:talk, category:, tags: ["tag2", "tag1"]) }
    let!(:talk2) { create(:talk, category: category2, tags: ["tag1", "tag3"]) }
    let!(:talk3) { create(:talk, category: category3, tags: ["tag2"]) }

    it "filters by category" do
      expect(described_class.filter_by_category(category.slug)).to match_array([talk])
      expect(described_class.filter_by_category(category2.slug)).to match_array([talk2])
      expect(described_class.filter_by_category(category3.slug)).to match_array([talk3])
    end

    it "filters by tags" do
      expect(described_class.filter_by_tag("tag2")).to match_array([talk, talk3])
      expect(described_class.filter_by_tag("tag1")).to match_array([talk, talk2])
      expect(described_class.filter_by_tag("tag3")).to match_array([talk2])
    end
  end
end
