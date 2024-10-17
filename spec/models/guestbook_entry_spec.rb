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
require "rails_helper"

RSpec.describe GuestbookEntry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
