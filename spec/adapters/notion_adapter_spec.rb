require 'rails_helper'

RSpec.describe NotionAdapter do
  let(:notion_adapter) { described_class.new }

  describe ".fetch_categories" do
    it "initializes and calls fetch_categories" do
      allow(NotionAdapter).to receive(:new) { OpenStruct.new(fetch_categories: []) }

      expect(NotionAdapter.fetch_categories).to eql([])
    end
  end

  describe ".fetch_posts" do
    it "initializes and calls fetch_posts" do
      allow(NotionAdapter).to receive(:new) { OpenStruct.new(fetch_posts: []) }

      expect(NotionAdapter.fetch_posts).to eql([])
    end
  end

  describe '#fetch_categories' do
    it 'fetches categories' do
      category_data = OpenStruct.new(
        id: 'category_id',
        properties: OpenStruct.new(
          Name: OpenStruct.new(title: [OpenStruct.new(plain_text: 'Category')]),
          Description: OpenStruct.new(rich_text: [OpenStruct.new(plain_text: 'Description')])
        ),
        last_edited_time: DateTime.now.to_s,
      )

      allow(notion_adapter).to receive(:fetch_records).and_return([category_data])
      categories = notion_adapter.fetch_categories

      expect(categories).to be_an(Array)
      expect(categories.size).to eq(1)
      expect(categories.first[:notion_id]).to eq('category_id')
      expect(categories.first[:title]).to eq('Category')
      expect(categories.first[:description]).to eq('Description')
    end
  end

  describe '#fetch_records' do
    it 'fetches records without filter' do
      allow(notion_adapter).to receive(:fetch_records).and_call_original
      allow(notion_adapter.instance_variable_get(:@client)).to receive(:database_query).with(database_id: 'db_id').and_yield(OpenStruct.new(results: [{ id: 'record_id' }]))

      records = notion_adapter.fetch_records('db_id')

      expect(records).to be_an(Array)
      expect(records.size).to eq(1)
      expect(records.first[:id]).to eq('record_id')
    end

    it 'fetches records with filter' do
      allow(notion_adapter).to receive(:fetch_records).and_call_original
      filter = { property: 'Type', select: { equals: 'Post' } }
      allow(notion_adapter.instance_variable_get(:@client)).to receive(:database_query).with(database_id: 'db_id', filter: filter).and_yield(OpenStruct.new(results: [{ id: 'record_id' }]))

      records = notion_adapter.fetch_records('db_id', filter)

      expect(records).to be_an(Array)
      expect(records.size).to eq(1)
      expect(records.first[:id]).to eq('record_id')
    end
  end

  describe '#fetch_posts' do
    it 'fetches posts' do
      allow(notion_adapter).to receive(:blocks_children).and_return('Content Blocks')
      allow(notion_adapter).to receive(:fetch_records).and_return([OpenStruct.new(
        id: 'post_id',
        properties: OpenStruct.new(
          Title: OpenStruct.new(title: [OpenStruct.new(plain_text: 'Post Title')]),
          Summary: OpenStruct.new(rich_text: [OpenStruct.new(plain_text: 'Summary')]),
          Published: OpenStruct.new(checkbox: true),
          Date: OpenStruct.new(date: OpenStruct.new(start: '2023-01-01')),
          Slug: OpenStruct.new(rich_text: [OpenStruct.new(plain_text: 'post-slug')]),
          Created: OpenStruct.new(created_time: '2023-01-01T12:00:00Z'),
          Tags: OpenStruct.new(multi_select: [OpenStruct.new(name: 'Tag1'), OpenStruct.new(name: 'Tag2')]),
          "Content Pillar": OpenStruct.new(relation: [OpenStruct.new(id: 'category_id')]),
          Status: OpenStruct.new(status: OpenStruct.new(name: 'Status')),
          "Cover Image": OpenStruct.new(files: [OpenStruct.new(name: 'image.jpg')]),
          "Meta Description": OpenStruct.new(rich_text: [OpenStruct.new(plain_text: 'Meta Description')]),
          "Meta Keywords": OpenStruct.new(multi_select: [OpenStruct.new(name: 'Keyword1'), OpenStruct.new(name: 'Keyword2')]),
        ),
        last_edited_time: DateTime.now.to_s,
      )])

      posts = notion_adapter.fetch_posts

      expect(posts).to be_an(Array)
      expect(posts.size).to eq(1)
      expect(posts.first[:notion_id]).to eq('post_id')
      expect(posts.first[:title]).to eq('Post Title')
      expect(posts.first[:description]).to eq('Summary')
      expect(posts.first[:published]).to eq(true)
      expect(posts.first[:published_date]).to eq('2023-01-01') # NoMethodError should be resolved
      expect(posts.first[:notion_slug]).to eq('post-slug')
      expect(posts.first[:notion_created_at]).to eq(DateTime.parse('2023-01-01T12:00:00Z'))
      expect(posts.first[:notion_updated_at]).to be_a(DateTime)
      expect(posts.first[:tags]).to eq(['Tag1', 'Tag2'])
      expect(posts.first[:category_notion_id]).to eq('category_id')
      expect(posts.first[:status]).to eq('Status')
      expect(posts.first[:cover_image]).not_to be_nil
      expect(posts.first[:meta_description]).to eq('Meta Description')
      expect(posts.first[:meta_keywords]).to eq(['Keyword1', 'Keyword2'])
      expect(posts.first[:content]).to eq('Content Blocks')
    end
  end
end
