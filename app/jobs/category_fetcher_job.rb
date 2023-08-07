class CategoryFetcherJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = Notion::Client.new
    all_categories = []
    client.database_query(database_id: ENV["NOTION_CATEGORY_DATABASE_ID"]) do |page|
      all_categories.concat(page.results)
    end

    return if all_categories.empty?

    all_categories.each do |category|
      Category.create(
        title: category.properties.Name.title.first.plain_text,
        notion_id: category.id,
        description: category.properties.Description.rich_text.reduce("") { |desc,txt| desc + txt.plain_text },
      )
    end
  end
end
