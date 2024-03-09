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
FactoryBot.define do
  factory :comment do
    content { "MyText" }
    author_name { "MyString" }
    author_email { "MyString" }
    author_website { "MyString" }
    notify_by_email { false }
    commentable { nil }
  end
end
