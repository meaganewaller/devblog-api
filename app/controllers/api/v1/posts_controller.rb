# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApiController
      def index
        all_posts = Post.published.includes([:category])
        @posts = if params[:recent]
                   all_posts.limit(5)
                 else
                   all_posts
                 end

        @posts = @posts.includes([:category]).filter_by_category(params[:category]) if params[:category].present?
        @posts = @posts.filter_by_tag(params[:tag]) if params[:tag].present?
        @posts = @posts.search_post(params[:query]) if params[:query].present?

        @pagy, @posts = pagy(@posts, items: params[:limit].to_i || 10)
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        @post = Post.friendly.find(params[:id])
      end
    end
  end
end
