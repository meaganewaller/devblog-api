# frozen_string_literal: true

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
class GuestbookEntry < ApplicationRecord
  scope :approved, -> { where(approved: true) }

  validates :body, presence: true
  validates :email, presence: true
  validates :name, presence: true
  validates :session_id, presence: true
end
