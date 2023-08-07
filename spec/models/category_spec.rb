# == Schema Information
#
# Table name: categories
#
#  id          :uuid             not null, primary key
#  description :string
#  posts_count :integer
#  slug        :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  notion_id   :string
#
# Indexes
#
#  index_categories_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Category, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
