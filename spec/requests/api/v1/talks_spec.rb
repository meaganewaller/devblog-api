# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Talks", type: :request, vcr: false do
  describe "GET /api/v1/talks" do
    it "responds with ok status" do
      get api_v1_talks_path, as: :json

      expect(response).to have_http_status :ok
    end

    it "limits the number of talks" do
      create_list(:talk, 10)
      get api_v1_talks_path, params: { limit: 5 }, as: :json

      expect(json_response["talks"].length).to eq 5
    end

    it "responds with talks" do
      talks = create_list(:talk, 3)

      get api_v1_talks_path, as: :json

      expect(json_response["talks"].length).to eq talks.count
    end

    it "filters by recent" do
      create_list(:talk, 10)

      get "/api/v1/talks.json", params: { recent: true }

      expect(response).to have_http_status(:success)
      expect(json_response["talks"].length).to eq(3)
    end

    it "filters talks by category" do
      category = create(:category)
      create_list(:talk, 2, category:)
      create_list(:talk, 3)

      get "/api/v1/talks.json", params: { category: category.slug }

      expect(response).to have_http_status(:success)
      expect(json_response["talks"].length).to eq(2)
    end

    it "filters posts by tag" do
      tag = "ruby"
      create_list(:talk, 3, tags: [tag])
      create_list(:talk, 2)

      get "/api/v1/talks.json", params: { tag: }

      expect(response).to have_http_status(:success)
      expect(json_response["talks"].length).to eq(3)
    end
  end

  describe "GET /api/v1/talks/:slug" do
    it "responds with talk" do
      talk = create(:talk)

      get api_v1_talk_path(talk.slug), as: :json

      expect(json_response["title"]).to eq talk.title
    end
  end
end
