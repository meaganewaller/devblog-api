require "rails_helper"

RSpec.describe "Api::V1::Posts", type: :request do
  describe 'GET /api/v1/posts' do
    it "responds with ok status" do
      get api_v1_posts_path

      expect(response).to have_http_status :ok
    end

    it "responds with posts" do
      published_posts = create_list(:post, 3, :published)
      unpublished_posts = create_list(:post, 3, :draft)

      get api_v1_posts_path

      expect(json.count).to eq published_posts.count
    end
  end

  describe 'GET /api/v1/posts/:slug' do
    it "responds with post" do
      post = create(:post, :published)
      create_list(:reaction, 3, :love, post:)
      create_list(:reaction, 2, :like, post:)
      create_list(:reaction, 4, :sparkle, post:)

      get api_v1_post_path(post.slug)

      expect(json["id"]).to eq post.id
      expect(json["title"]).to eq post.title
      expect(json["reactions"]).to eq({
        "love" => 3,
        "like" => 2,
        "sparkle" => 4
      })
    end
  end
end
