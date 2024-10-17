require "rails_helper"

RSpec.describe "Api::V1::GuestbookEntries", type: :request do
  describe "GET /api/v1/guestbook_entries" do
    it "responds with ok status" do
      get "/api/v1/guestbook"

      expect(response).to have_http_status :ok
    end

    it "responds with limited guestbook entries" do
      create_list :guestbook_entry, 10, approved: true
      get "/api/v1/guestbook", params: {limit: 5}

      expect(json_response["entries"].length).to eq 5
    end
  end

  describe "POST /api/v1/guestbook_entries" do
    it "responds with created status" do
      post "/api/v1/guestbook", as: :json,
        params: {
          guestbook_entry: {
            name: "John Doe",
            body: "Hello",
            email: "test@example.com",
            website: "http://example.com",
            session_id: "123abc"
          }
        }

      expect(response).to have_http_status :created
    end

    it "responds with unprocessable_entity status if guestbook entry is invalid" do
      post "/api/v1/guestbook", as: :json, params: {guestbook_entry: {name: "John Doe"}}

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
