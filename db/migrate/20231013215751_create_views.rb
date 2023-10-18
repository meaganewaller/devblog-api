class CreateViews < ActiveRecord::Migration[7.0]
  def change
    create_table :views, id: :uuid do |t|
      t.string :session_id, null: false
      t.references :viewable, polymorphic: true, null: false, type: :uuid
      t.index %w[session_id viewable_type viewable_id],
              name: 'index_views_on_session_id_and_viewable_type_and_viewable_id', unique: true
      t.index ['session_id'], name: 'index_views_on_session_id'

      t.timestamps
    end
  end
end
