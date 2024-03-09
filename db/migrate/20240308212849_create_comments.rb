class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments, id: :uuid do |t|
      t.text :content, null: false
      t.string :author_name, null: false
      t.string :author_email, null: false
      t.string :author_website
      t.boolean :notify_by_email, null: false, default: false
      t.references :commentable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
