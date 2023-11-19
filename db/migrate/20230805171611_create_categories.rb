# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :title
      t.string :description
      t.integer :posts_count

      t.timestamps
    end
  end
end
