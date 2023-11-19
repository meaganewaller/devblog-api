# frozen_string_literal: true

class RemoveCategoryFromPost < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :posts, :category, :string }
  end
end
