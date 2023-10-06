require 'rails_helper'

RSpec.describe 'POST /api/v1/post_comments' do
  let!(:blog_post) { create(:post, title: 'Sample Title') }

  scenario 'adding a post comment' do
    post '/api/v1/post_comments', params: {
      discussion_comment: {
        discussion: {
          title: 'Sample Title'
        },
        action: 'created'
      }
    }, as: :json

    expect(response.status).to eq 201
    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:comment_count]).to eq(1)
    expect(blog_post.reload.comment_count).to eq(1)
  end

  scenario 'deleting a post comment' do
    blog_post.increment!(:comment_count)
    post '/api/v1/post_comments', params: {
      discussion_comment: {
        discussion: {
          title: 'Sample Title'
        },
        action: 'deleted'
      }
    }, as: :json

    expect(response.status).to eq 201
    json = JSON.parse(response.body).deep_symbolize_keys

    expect(json[:comment_count]).to eq(0)
    expect(blog_post.reload.comment_count).to eq(0)
  end

  scenario 'comment for non-existent post' do
    post '/api/v1/post_comments', params: {
      discussion_comment: {
        discussion: {
          title: 'Non-existent Title'
        },
        action: 'created'
      }
    }, as: :json

    expect(response.status).to eq 204
  end
end
