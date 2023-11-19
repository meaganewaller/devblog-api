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
FactoryBot.define do
  factory :reaction do
    post
    kind { Reaction.kinds.keys.sample }
    session_id { Faker::Internet.uuid }

    trait :like do
      kind { :like }
    end

    trait :love do
      kind { :love }
    end

    trait :haha do
      kind { :haha }
    end

    trait :wow do
      kind { :wow }
    end

    trait :til do
      kind { :til }
    end

    trait :sparkle do
      kind { :sparkle }
    end
  end
end
