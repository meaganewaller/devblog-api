# == Schema Information
#
# Table name: guestbook_entries
#
#  id         :uuid             not null, primary key
#  approved   :boolean          default(FALSE), not null
#  body       :text             not null
#  email      :string           not null
#  name       :string           not null
#  website    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :string           not null
#
FactoryBot.define do
  factory :guestbook_entry do
    body { Faker::Lorem.paragraph }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    website { Faker::Internet.url }
    session_id { Faker::Internet.uuid }
    approved { false }
  end
end
