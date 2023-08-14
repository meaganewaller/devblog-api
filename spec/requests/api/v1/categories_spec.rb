require "rails_helper"

RSpec.describe "Api::V1::Categories", type: :request do
  describe 'GET /api/v1/categories' do
    it "responds with ok status" do
      get api_v1_categories_path

      expect(response).to have_http_status :ok
    end

    it "responds with categories" do
      categories = create_list(:category, 3)

      get api_v1_categories_path

      expect(json_response.count).to eq categories.count
    end
  end

  describe 'GET /api/v1/categories/:slug' do
    it "responds with category" do
      category = create(:category)

      get api_v1_category_path(category.slug)

      expect(json_response["id"]).to eq category.id
      expect(json_response["title"]).to eq category.title
      expect(json_response["posts_count"]).to eq category.posts_count
    end
  end
end

