# frozen_string_literal: true

class AddSearchableColumnToPosts < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    safety_assured do
      execute <<-SQL
    ALTER TABLE posts
    ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
      setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
      setweight(to_tsvector('english', coalesce(description, '')), 'B') ||
      setweight(to_tsvector('english', coalesce(content,'')), 'C')
    ) STORED;
      SQL
    end

    add_index :posts, :searchable, using: :gin, algorithm: :concurrently
  end

  def down
    remove_column :posts, :searchable
    remove_index :posts, :searchable
  end
end
