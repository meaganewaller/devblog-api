# frozn_string_literal: true

require 'rails_helper'

RSpec.describe NotionAdapter do
  describe '#fetch_categories' do
    # it 'returns transformed categories', vcr: { record: :new_episodes } do
    #   adapter = NotionAdapter.new
    #   categories = adapter.fetch_categories
    #
    #   expect(categories).to include(hash_including(
    #                                   notion_id: an_instance_of(String),
    #                                   title: an_instance_of(String),
    #                                   description: an_instance_of(String),
    #                                   cover_image: an_instance_of(Hash),
    #                                   last_edited_time: an_instance_of(DateTime)
    #                                 ))
    # end
  end

  describe '#fetch_posts' do
    # it 'returns transformed posts', vcr: { record: :new_episodes } do
    #   adapter = NotionAdapter.new
    #   posts = adapter.fetch_posts
    #
    #   expect(posts).to include(hash_including(
    #                              notion_id: an_instance_of(String),
    #                              title: an_instance_of(String),
    #                              description: an_instance_of(String),
    #                              cover_image: an_instance_of(String) || an_instance_of(Hash),
    #                              notion_created_at: an_instance_of(DateTime),
    #                              notion_updated_at: an_instance_of(DateTime),
    #                              tags: an_instance_of(Array),
    #                              category_notion_id: an_instance_of(String),
    #                              content: an_instance_of(String),
    #                              meta_description: an_instance_of(String)
    #                            ))
    # end
  end
end
