# frozen_string_literal: true

# This job is the base class for the jobs related to creating and updating talks.
class BaseTalkJob < ApplicationJob
  queue_as :default

  protected

  def get_cover_image(cover_image)
return if cover_image.blank? || cover_image.empty? || cover_image.nil?
    return cover_image["external"]["url"] if cover_image["type"] == "external"
    return unless cover_image["type"] == "file"

    cover_image["file"]["url"]
  end

  def get_category_id(category_notion_id)
    Category.find_by(notion_id: category_notion_id)&.id
  end

  def talk_params(talk)
    {
      content: talk[:content],
      category_id: get_category_id(talk[:category_notion_id]),
      description: talk[:description],
      meta_description: talk[:meta_description],
      notion_created_at: talk[:notion_created_at],
      notion_id: talk[:notion_id],
      notion_updated_at: talk[:notion_updated_at],
      date: talk[:date],
      tags: talk[:tags],
      title: talk[:title]
    }
  end
end
