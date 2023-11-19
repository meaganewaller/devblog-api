# frozen_string_literal: true

class AddNotionIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :notion_id, :string, null: false
  end
end
