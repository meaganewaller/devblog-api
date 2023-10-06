# frozen_string_literal: true

module Api
  module V1
    class PostCommentsController < ApiController
      def create
        post = Post.find_by(title: params['discussion_comment']['discussion']['title'])

        if post && params['discussion_comment']['action'] == 'created'
          post.increment!(:comment_count)
          render json: post, status: :created
        elsif post && params['discussion_comment']['action'] == 'deleted'
          post.decrement!(:comment_count)
          render json: post, status: :created
        end
      end
    end
  end
end
