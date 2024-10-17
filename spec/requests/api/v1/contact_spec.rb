# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Contact', type: :request, vcr: false do
  describe 'POST /api/v1/contact' do
    it 'responds with created status', vcr: false do
      allow(Notion::Client).to receive(:new) { double(create_page: true) }
      contact_params = { name: 'John Doe', email: 'john.doe@test.com', subject: 'Hello', message: 'Hello, World!' }

      post api_v1_contact_path, params: { contact: contact_params }, as: :json

      expect(response).to have_http_status :created
    end

    it 'responds with unprocessable_entity status' do
      contact_params = { name: 'John Doe', email: '', subject: 'Hello', message: 'Hello, World!' }

      post api_v1_contact_path, params: { contact: contact_params }, as: :json

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
