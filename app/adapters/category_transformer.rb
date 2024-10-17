# frozen_string_literal: true

# This class is responsible for transforming category records from Notion.
class CategoryTransformer < NotionTransformer
  CATEGORY_PROPERTY_NAMES = {
    description: "Content"
  }.freeze
  # Transforms a category record from the Notion database.
  def transform
    {
      notion_id: record.fetch(:id),
      title: from_title(properties[PROPERTY_NAMES[:title]]),
      description: from_rich_text(properties[CATEGORY_PROPERTY_NAMES[:description]]),
      cover_image: from_files(properties[PROPERTY_NAMES[:cover_image]]),
      last_edited_time: record.last_edited_time.to_datetime
    }
  end
end
