# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :title, null: false
      t.string :link
      t.text :description, null: false
      t.text :tags, array: true, default: []
      t.boolean :featured, default: false
      t.string :slug, null: false
      t.json :repository_links, default: {}
      t.string :notion_id, null: false
      t.text :content, null: false
      t.timestamp :notion_created_at, null: false
      t.timestamp :notion_updated_at, null: false

      t.index :title, unique: true
      t.index :notion_id, unique: true
      t.index :tags, using: :gin
      t.index :slug, unique: true

      t.timestamps
    end
  end
end
