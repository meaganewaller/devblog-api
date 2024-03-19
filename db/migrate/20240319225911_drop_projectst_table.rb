class DropProjectstTable < ActiveRecord::Migration[7.0]
  drop_table :projects do |t|
    t.string 'title', null: false
    t.string 'link'
    t.text 'description', null: false
    t.text 'tags', default: [], array: true
    t.boolean 'featured', default: false
    t.string 'slug', null: false
    t.json 'repository_links', default: {}
    t.string 'notion_id', null: false
    t.text 'content', null: false
    t.datetime 'notion_created_at', precision: nil, null: false
    t.datetime 'notion_updated_at', precision: nil, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'cover_image'
    t.index ['notion_id'], name: 'index_projects_on_notion_id', unique: true
    t.index ['slug'], name: 'index_projects_on_slug', unique: true
    t.index ['tags'], name: 'index_projects_on_tags', using: :gin
    t.index ['title'], name: 'index_projects_on_title', unique: true
  end
end
