# frozen_string_literal: true

class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions, id: :uuid do |t|
      t.references :post, null: false, foreign_key: true, type: :uuid
      t.integer :kind, null: false

      t.timestamps
    end
  end
end
