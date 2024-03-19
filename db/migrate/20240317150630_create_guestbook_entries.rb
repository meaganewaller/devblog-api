class CreateGuestbookEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :guestbook_entries, id: :uuid do |t|
      t.text :body, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :session_id, null: false
      t.boolean :approved, null: false, default: false

      t.timestamps
    end
  end
end
