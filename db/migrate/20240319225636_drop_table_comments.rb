class DropTableComments < ActiveRecord::Migration[7.0]
  drop_table :comments do |t|
    t.text 'content', null: false
    t.string 'author_name', null: false
    t.string 'author_email', null: false
    t.string 'author_website'
    t.boolean 'notify_by_email', default: false, null: false
    t.string 'commentable_type', null: false
    t.uuid 'commentable_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[commentable_type commentable_id], name: 'index_comments_on_commentable'
  end
end
