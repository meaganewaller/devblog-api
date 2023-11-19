# frozen_string_literal: true

class AddViewableSlugToView < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :views, :viewable_slug, :string, null: false
    add_index :views, %i[viewable_slug viewable_type], algorithm: :concurrently
    add_index :views, %i[viewable_slug viewable_type session_id], unique: true, algorithm: :concurrently

    safety_assured { remove_column :views, :viewable_id, :uuid }
  end
end
