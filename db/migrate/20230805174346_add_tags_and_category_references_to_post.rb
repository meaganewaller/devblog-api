class AddTagsAndCategoryReferencesToPost < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :posts, :category, index: { algorithm: :concurrently }, type: :uuid
  end
end
