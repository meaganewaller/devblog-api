class AddWebsiteToGuestbookEntry < ActiveRecord::Migration[7.0]
  def change
    add_column :guestbook_entries, :website, :string
  end
end
