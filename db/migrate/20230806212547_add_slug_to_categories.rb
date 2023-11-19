# frozen_string_literal: true

class AddSlugToCategories < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true, algorithm: :concurrently
  end
end
