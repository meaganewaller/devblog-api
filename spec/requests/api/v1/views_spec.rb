# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Views', type: :request, vcr: false do
  describe 'GET /api/v1/posts/:slug/views' do
    it 'responds with ok status' do
      post = create(:post, :published)
      create(:view, viewable: post)

      get api_v1_views_path, as: :json, params: { viewable_slug: post.slug, viewable_type: 'Post' }

      expect(response).to have_http_status :ok
    end

    it 'responds with views' do
      post = create(:post, :published)
      view = create(:view, viewable: post)

      get api_v1_views_path, as: :json, params: { viewable_slug: post.slug, viewable_type: 'Post' }

      expect(json_response[0]['type']).to eq 'Post'
      expect(json_response[0]['slug']).to eq post.slug
      expect(json_response[0]['count']).to eq 1
    end
  end

  describe 'POST /api/v1/views' do
    it 'responds with created status' do
      post = create(:post, :published)

      post api_v1_views_path, as: :json, params: { viewable_slug: post.slug, viewable_type: 'Post', session_id: '123' }

      expect(response).to have_http_status :created
    end

    it 'responds with ok status if view already exists' do
      post = create(:post, :published)
      create(:view, viewable: post, session_id: '123')

      post api_v1_views_path, as: :json, params: { viewable_slug: post.slug, viewable_type: 'Post', session_id: '123' }

      expect(response).to have_http_status :ok
    end

    it 'responds with unprocessable_entity status if view is invalid' do
      post = create(:post, :published)

      post api_v1_views_path, as: :json, params: { viewable_slug: post.slug, viewable_type: 'Post' }

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
