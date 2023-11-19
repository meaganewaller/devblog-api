# frozen_string_literal: true

# == Schema Information
#
# Table name: views
#
#  id            :uuid             not null, primary key
#  viewable_slug :string           not null
#  viewable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  session_id    :string           not null
#
# Indexes
#
#  index_views_on_session_id                                      (session_id)
#  index_views_on_viewable_slug_and_viewable_type                 (viewable_slug,viewable_type)
#  index_views_on_viewable_slug_and_viewable_type_and_session_id  (viewable_slug,viewable_type,session_id) UNIQUE
#
class View < ApplicationRecord
  belongs_to :viewable, polymorphic: true, primary_key: :slug, foreign_key: :viewable_slug

  validates :session_id, presence: true, uniqueness: {scope: %i[viewable_slug viewable_type]}
  counter_culture :viewable
end
