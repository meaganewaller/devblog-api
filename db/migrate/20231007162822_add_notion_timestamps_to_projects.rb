class AddNotionTimestampsToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :notion_created_at, :timestamp, null: false
    add_column :projects, :notion_updated_at, :timestamp, null: false
  end
end
