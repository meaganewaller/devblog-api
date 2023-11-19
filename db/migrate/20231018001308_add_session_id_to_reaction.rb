# frozen_string_literal: true

class AddSessionIdToReaction < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :reactions, :session_id, :string, null: false
    add_index :reactions, %i[session_id kind post_id], unique: true, algorithm: :concurrently
  end
end
