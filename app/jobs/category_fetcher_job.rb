# frozen_string_literal: true

class CategoryFetcherJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    categories = NotionAdapter.fetch_categories

    return if categories.empty?

    categories.each do |category|
      found_category = Category.find_by(notion_id: category[:notion_id])
      next if found_category && found_category.updated_at > category[:last_edited_time].to_datetime

      update_category(found_category, category) if found_category
      create_category(category)
    end
  end

  private

  def update_category(found_category, category)
    found_category.update(
      title: category[:title],
      description: category[:description],
      notion_id: category[:notion_id]
    )
  end

  def create_category(category)
    Category.create(
      title: category[:title],
      description: category[:description],
      notion_id: category[:notion_id]
    )
  end
end
