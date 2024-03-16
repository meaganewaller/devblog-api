class DropDateColumnsFromPosts < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      remove_column :posts, :notion_created_at
      remove_column :posts, :notion_updated_at

      # Rename the new columns to match the old column names if needed
      rename_column :posts, :new_notion_created_at, :notion_created_at
      rename_column :posts, :new_notion_updated_at, :notion_updated_at
    end
  end
end
