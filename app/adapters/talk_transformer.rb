# frozen_string_literal: true

# This class is responsible for transforming talk records from Notion.
class TalkTransformer < NotionTransformer
  def transform
    {
      category_notion_id: extract_category_id,
      content: fetch_content,
      cover_image: fetch_cover_image,
      description: fetch_description,
      meta_description: fetch_meta_description,
      notion_created_at: parse_notion_created_at,
      notion_id: record.id,
      notion_updated_at: parse_notion_updated_at,
      date: parse_date,
      tags: fetch_tags,
      title: fetch_title
    }
  end

  private

  def fetch_content
    blocks_children(record.fetch(:id))
  end

  def fetch_cover_image
    from_files(properties[PROPERTY_NAMES[:cover_image]])
  end

  def fetch_description
    from_rich_text(properties[PROPERTY_NAMES[:summary]]) || "Description not available."
  end

  def fetch_meta_description
    from_rich_text(properties["Meta Description"])
  end

  def parse_notion_created_at
    DateTime.parse(properties.Created.created_time)
  end

  def parse_notion_updated_at
    DateTime.parse(record.last_edited_time)
  end

  def parse_date
    date_property = properties[PROPERTY_NAMES[:publication_date]]&.date
    date_property&.start
  end

  def fetch_tags
    properties.Tags&.multi_select&.map(&:name) || []
  end

  def fetch_title
    from_title(properties[PROPERTY_NAMES[:title]])
  end

  def extract_category_id
    properties["🌱 Content Pillar"]&.relation&.first&.id || ""
  end
end
