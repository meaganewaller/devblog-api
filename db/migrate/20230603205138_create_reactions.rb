# frozen_string_literal: true

class CreateReactions < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    create_table :reactions, id: :uuid do |t|
      t.references :post, null: false, foreign_key: true, type: :uuid
      t.integer :kind, null: false
      t.string :session_id, null: false

      t.timestamps

      t.index %i[post_id session_id kind], unique: true, algorithm: :concurrently
    end
  end
end
