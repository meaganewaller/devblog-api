class CreateTalks < ActiveRecord::Migration[7.0]
  def change
    create_table :talks, id: :uuid do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.date :date
      t.string :slug, null: false
      t.string :tags, default: [], array: true
      t.string :notion_id, null: false
      t.text :content, null: false
      t.references :category, null: false, foreign_key: true, type: :uuid
      t.string :meta_description
      t.string :cover_image
      t.integer :comment_count, default: 0, null: false
      t.integer :views_count, default: 0, null: false
      t.datetime :notion_created_at
      t.datetime :notion_updated_at

      t.timestamps
    end
  end
end
