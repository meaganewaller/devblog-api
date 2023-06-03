class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    enable_extension('btree_gin')
    create_table :posts, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.boolean :published, null: false, default: false, index: true
      t.date :published_date
      t.string :slug, null: false, index: { unique: true }
      t.string :tags, array: true, default: '{}'
      t.string :notion_id, null: false
      t.string :language
      t.text :content
      t.date :notion_created_at, null: false
      t.date :notion_updated_at, null: false
      t.string :notion_slug, null: false, index: { unique: true }

      t.timestamps

      t.index :tags, using: :gin
    end
  end
end
