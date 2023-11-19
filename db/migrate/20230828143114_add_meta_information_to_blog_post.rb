# frozen_string_literal: true

class AddMetaInformationToBlogPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :meta_description, :string
    add_column :posts, :meta_keywords, :text, array: true, default: []
    add_column :posts, :cover_image, :string
  end
end
