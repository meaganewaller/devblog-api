# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApiController
      def index
        @posts = Post.includes([:category]).published
        @posts = @posts.filter_by_category(params[:category]) if params[:category].present?
        @posts = @posts.filter_by_tag(params[:tag]) if params[:tag].present?
        @posts = @posts.search_post(params[:query]) if params[:query].present?

        @pagy, @posts = pagy(@posts, items: 10)
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        @post = Post.friendly.find(params[:id])
      end
    end
  end
end
