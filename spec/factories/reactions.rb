# frozen_string_literal: true

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
#  index_reactions_on_post_id_and_session_id_and_kind  (post_id,session_id,kind) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
FactoryBot.define do
  factory :reaction do
    post { create(:post, :published) }
    kind { Reaction.kinds.keys.sample }
    session_id { Faker::Internet.uuid }
  end
end
