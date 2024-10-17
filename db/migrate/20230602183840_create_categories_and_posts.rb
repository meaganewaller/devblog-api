# frozen_string_literal: true

class CreateCategoriesAndPosts < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    enable_extension("btree_gin")

    create_table :categories, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :title, null: false, index: {unique: true}
      t.string :description, null: false
      t.string :slug, null: false, index: {unique: true}
      t.string :notion_id, null: false, index: {unique: true}
      t.string :cover_image
    end

    create_table :posts, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :title, null: false, index: {unique: true}
      t.string :description, null: false
      t.boolean :published, null: false, default: false, index: true
      t.date :published_date
      t.string :slug, null: false, index: {unique: true}
      t.string :tags, array: true, default: []
      t.string :notion_id, null: false, index: {unique: true}
      t.text :content, null: false
      t.date :notion_created_at, null: false
      t.date :notion_updated_at, null: false
      t.references :category, type: :uuid, null: false, foreign_key: true, index: {algorithm: :concurrently}

      t.string :meta_description
      t.string :cover_image
      t.integer :comment_count, null: false, default: 0

      t.timestamps

      t.index :tags, using: :gin
    end
  end
end
