# == Schema Information
#
# Table name: comments
#
#  id               :uuid             not null, primary key
#  author_email     :string           not null
#  author_name      :string           not null
#  author_website   :string
#  commentable_type :string           not null
#  content          :text             not null
#  notify_by_email  :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :uuid             not null
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
