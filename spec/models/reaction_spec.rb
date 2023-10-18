# == Schema Information
#
# Table name: reactions
#
#  id         :uuid             not null, primary key
#  kind       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :uuid             not null
#  session_id :string           not null
#
# Indexes
#
#  index_reactions_on_post_id                          (post_id)
#  index_reactions_on_session_id_and_kind_and_post_id  (session_id,kind,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
require "rails_helper"

RSpec.describe Reaction, type: :model do
  describe "validations" do
    it { should validate_presence_of(:kind) }
  end

  describe "associations" do
    it { should belong_to(:post).inverse_of(:reactions) }
  end

  describe "enums" do
    it { should define_enum_for(:kind).with_values(like: 0, love: 1, til: 2, haha: 3, wow: 4, sparkle: 5) }
  end
end
