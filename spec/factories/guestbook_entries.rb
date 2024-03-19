# == Schema Information
#
# Table name: guestbook_entries
#
#  id         :uuid             not null, primary key
#  approved   :boolean          default(FALSE), not null
#  body       :text             not null
#  email      :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :string           not null
#
FactoryBot.define do
  factory :guestbook_entry do
    body { "MyText" }
    name { "MyString" }
    email { "MyString" }
    session_id { "MyString" }
    approved { false }
  end
end
