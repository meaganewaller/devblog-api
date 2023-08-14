class AddMissingIndices < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    add_index :categories, :notion_id, algorithm: :concurrently
    add_index :posts, :notion_id, algorithm: :concurrently
  end
end
