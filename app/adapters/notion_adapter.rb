# frozen_string_literal: true

# This class is responsible for interacting with the Notion API.
# It fetches records from different Notion databases.
class NotionAdapter
  attr_reader :client

  # @return [Hash] the IDs of the Notion databases
  DATABASE_IDS = {
    blog: ENV['NOTION_BLOG_DATABASE_ID'],
    category: ENV['NOTION_CATEGORY_DATABASE_ID']
  }.freeze

  class << self
    # Service method to fetch categories from the Notion database.
    #
    # @return [Array] an array of transformed categories
    def fetch_categories
      new.fetch_categories
    end

    # Service method to fetch posts from the Notion database.
    #
    # @return [Array] an array of transformed posts
    def fetch_posts
      new.fetch_posts
    end
  end

  # Initializes a new instance of the NotionAdapter class.
  #
  # @param client [Notion::Client] the Notion client
  # @return [NotionAdapter] the NotionAdapter instance
  def initialize(client = Notion::Client.new)
    @client = client
  end

  # Fetches categories from the Notion database.
  # @return [Array] an array of transformed categories
  def fetch_categories
    fetch_records(DATABASE_IDS[:category]).map do |category|
      CategoryTransformer.transform(client, category)
    end
  end

  # Fetches posts from the Notion database.
  # @return [Array] an array of transformed posts
  def fetch_posts
    fetch_records(
      DATABASE_IDS[:blog],
      blog_post_filters,
      blog_post_sorts
    ).map do |post|
      return nil unless post

      PostTransformer.transform(client, post)
    end
  end

  private

  # @return [Array] an array of blog post sorts
  def blog_post_sorts
    [
      {
        property: 'Date',
        direction: 'descending'
      }
    ]
  end

  # @return [Hash] the filters for blog posts
  def blog_post_filters
    {
      'and': [
        {
          property: 'Type',
          select: {
            equals: 'Post'
          }
        },
        {
          property: 'Published',
          checkbox: {
            equals: true
          }
        }
      ]
    }
  end

  # Fetches records from the Notion database.
  #
  # @param database_id [String] the ID of the Notion database
  # @param filter      [Hash] the filter for the records
  # @param sorts       [Array] the sorts for the records
  # @return [Array]    an array of records
  def fetch_records(database_id, filter = nil, sorts = nil)
    records = []
    query_options = { database_id: }
    query_options[:filter] = filter if filter
    query_options[:sorts] = sorts if sorts

    client.database_query(query_options) do |page|
      records.concat(page.results)
    end
    records
  end
end
