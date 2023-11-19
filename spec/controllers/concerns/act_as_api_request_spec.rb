# frozen_string_literal: true
require "rails_helper"

RSpec.describe "ActAsApiRequest", type: :controller do
  controller(ApplicationController) do
    include ActAsApiRequest

    def index
      head :ok
    end

    def create
    end
  end

  describe "#check_request_type" do
    context "when the request content type is json" do
      it "does not render an error response" do
        request.headers["Content-Type"] = "application/json"

        get :index

        expect(response).to have_http_status(:ok)
      end
    end

    context "when the request content type is form-data" do
      it "does not render an error response" do
        request.headers["Content-Type"] = "multipart/form-data"

        get :index

        expect(response).to have_http_status(:ok)
      end
    end

    context "when the request content type is invalid" do
      it "renders a bad request error response" do
        request.headers["Content-Type"] = "text/xml"

        post :create, params: {something: {idk: "test"}}, as: :xml

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include(I18n.t("errors.invalid_content_type"))
      end
    end

    context "when the request body is empty" do
      it "does not render an error response" do
        get :index

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
