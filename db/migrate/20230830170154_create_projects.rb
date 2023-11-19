# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :repository_url
      t.string :homepage_url
      t.text :tags, array: true, default: []
      t.text :contributors, array: true, default: []
      t.string :license
      t.date :creation_date
      t.date :last_update
      t.string :demo_screenshot_urls, array: true, default: []
      t.boolean :featured, default: false
      t.integer :status, default: 0
      t.integer :open_issues, default: 0
      t.integer :pull_requests, default: 0
      t.string :language
      t.string :framework
      t.string :difficulty_level
      t.string :documentation_url
      t.string :slug, null: false

      t.index :title, unique: true
      t.index :tags, using: :gin
      t.index :language
      t.index :featured
      t.index :slug, unique: true

      t.timestamps
    end
  end
end
