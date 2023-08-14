require "rails_helper"

RSpec.describe "Api::V1::Posts", type: :request do
  describe 'GET /api/v1/posts' do
    it "responds with ok status" do
      get api_v1_posts_path

      expect(response).to have_http_status :ok
    end

    it "responds with posts" do
      published_posts = create_list(:post, 3, :published)
      unpublished_posts = create_list(:post, 1, :drafting)

      get api_v1_posts_path

      expect(json_response.count).to eq published_posts.count
    end

    it "filters posts by category" do
      category = create(:category)
      create_list(:post, 2, :published, category: category)
      create_list(:post, 3, :published)

      get "/api/v1/posts", params: { category: category.slug }

      expect(response).to have_http_status(:success)
      expect(json_response.length).to eq(2)
    end

    it "filters posts by tag" do
      tag = "ruby"
      create_list(:post, 3, :published,tags: [tag])
      create_list(:post, 2, :published)

      get "/api/v1/posts", params: { tag: tag }

      expect(response).to have_http_status(:success)
      expect(json_response.length).to eq(3)
    end

  end

  describe 'GET /api/v1/posts/:slug' do
    it "responds with post" do
      post = create(:post, :published)
      create_list(:reaction, 3, :love, post:)
      create_list(:reaction, 2, :like, post:)
      create_list(:reaction, 4, :sparkle, post:)

      get api_v1_post_path(post.slug)

      expect(json_response["id"]).to eq post.id
      expect(json_response["title"]).to eq post.title
      expect(json_response["reactions"]).to eq({
        "love" => 3,
        "like" => 2,
        "sparkle" => 4
      })
    end
  end
end
