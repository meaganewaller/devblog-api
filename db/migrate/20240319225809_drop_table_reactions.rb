class DropTableReactions < ActiveRecord::Migration[7.0]
  drop_table :reactions do |t|
    t.uuid "post_id", null: false
    t.integer "kind", null: false
    t.string "session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index %w[post_id session_id kind], name: "index_reactions_on_post_id_and_session_id_and_kind", unique: true
    t.index ["post_id"], name: "index_reactions_on_post_id"
  end
end
