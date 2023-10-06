require "rails_helper"

RSpec.describe "Api::V1::Categories", type: :request do
  describe 'GET /api/v1/categories' do
    it "responds with ok status" do
      get api_v1_categories_path, as: :json

      expect(response).to have_http_status :ok
    end

    it "responds with categories" do
      categories = create_list(:category, 3)

      get api_v1_categories_path, as: :json

      expect(json_response.count).to eq categories.count
    end

    context "when published_only flag set" do
      it "responds only with published posts" do
        categories = create_list(:category, 3)
        create(:post, category: categories[1], published: true)

        get "/api/v1/categories.json", params: { published_only: true }

        expect(json_response.count).to eq(1)
        expect(json_response[0]["title"]).to eq(categories[1].title)
      end
    end
  end

  describe 'GET /api/v1/categories/:slug' do
    it "responds with category" do
      category = create(:category)

      get api_v1_category_path(category.slug), as: :json

      expect(json_response["id"]).to eq category.id
      expect(json_response["title"]).to eq category.title
    end
  end
end

