# frozen_string_literal: true

class AddViewsCountToPosts < ActiveRecord::Migration[7.0]
  def self.up
    add_column :posts, :views_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :posts, :views_count
  end
end
