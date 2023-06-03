# == Schema Information
#
# Table name: reactions
#
#  id         :uuid             not null, primary key
#  kind       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :uuid             not null
#
# Indexes
#
#  index_reactions_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
FactoryBot.define do
  factory :reaction do
    post { nil }
    value { 1 }
  end
end
