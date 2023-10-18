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
require 'rails_helper'

RSpec.describe View, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
