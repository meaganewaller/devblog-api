# frozen_string_literal: true

# This job is the base class for the jobs related to creating and updating posts.
class BasePostJob < ApplicationJob
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

  # rubocop:disable Metrics/MethodLength
  def post_params(post)
    {
      content: post[:content],
      category_id: get_category_id(post[:category_notion_id]),
      description: post[:description],
      meta_description: post[:meta_description],
      notion_created_at: post[:notion_created_at],
      notion_id: post[:notion_id],
      notion_updated_at: post[:notion_updated_at],
      published: post[:published],
      published_date: post[:published_date],
      tags: post[:tags],
      title: post[:title]
    }
  end
  # rubocop:enable Metrics/MethodLength
end
