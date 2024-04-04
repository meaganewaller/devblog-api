# frozen_string_literal: true

class CategoryFetcherJob < ApplicationJob
  queue_as :default

  def perform
    fetched_categories = NotionAdapter.fetch_categories

    return if fetched_categories.empty?

    fetched_categories.each do |fetched_category|
      existing_category = Category.find_by(notion_id: fetched_category[:notion_id])
      update_or_create_category(existing_category, fetched_category)
    end
  end

  private

  def update_or_create_category(existing_category, fetched_category)
    if existing_category && !skip?(existing_category, fetched_category)
      update_category(existing_category, fetched_category)
    elsif !existing_category
      create_post(fetched_category)
    end
  end

  def skip?(existing_category, fetched_category)
    existing_category &&
      existing_category.updated_at >= fetched_category[:last_edited_time].to_datetime
  end

  def update_category(existing_category, fetched_category)
    Rails.logger.info("Updating category: #{existing_category.title}")
    existing_category.update!(category_params(fetched_category))
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def create_category(category)
    Category.create!(category_params(category))
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Validation error: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("An error occurred during update: #{e.message}")
  end

  def category_params(category)
    {
      cover_image: get_cover_image(category[:cover_image]),
      description: category[:description],
      title: category[:title],
      notion_id: category[:notion_id]
    }
  end

  def get_cover_image(cover_image)
    return if cover_image.blank? || cover_image.empty? || cover_image.nil?
    return cover_image['external']['url'] if cover_image['type'] == 'external'

    return unless cover_image['type'] == 'file'

    cover_image['file']['url']
  end
end
