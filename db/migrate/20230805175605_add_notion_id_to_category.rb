class AddNotionIdToCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :notion_id, :string
  end
end
