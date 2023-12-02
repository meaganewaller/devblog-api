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
class Reaction < ApplicationRecord
  belongs_to :post, inverse_of: :reactions

  enum kind: {
    like: 0,
    love: 1,
    til: 2,
    haha: 3,
    wow: 4,
    sparkle: 5
  }

  validates :kind, presence: true
end
