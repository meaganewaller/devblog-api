class AddDatetimeColumnsToPosts < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :posts, :new_notion_created_at, :datetime unless column_exists?(:posts, :new_notion_created_at)
    add_column :posts, :new_notion_updated_at, :datetime unless column_exists?(:posts, :new_notion_updated_at)

    # Update the new columns with data from the old columns
    Post.find_each do |post|
      post.update_columns(new_notion_created_at: post.notion_created_at.to_datetime,
                          new_notion_updated_at: post.notion_updated_at.to_datetime)
    end

    # Optionally, add index for the new columns if needed
    add_index :posts, :new_notion_created_at, algorithm: :concurrently
    add_index :posts, :new_notion_updated_at, algorithm: :concurrently
  end
end
