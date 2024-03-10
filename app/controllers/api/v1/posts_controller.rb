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

        if params[:category].present? && !params[:recent]
          @posts = @posts.includes([:category]).filter_by_category(params[:category])
        end
        @posts = @posts.filter_by_tag(params[:tag]) if params[:tag].present? && !params[:recent]
        @posts = @posts.search_post(params[:query]) if params[:query].present? && !params[:recent]

        limit = params[:recent] ? 5 : params[:limit].to_i || 10

        @pagy, @posts = pagy(@posts, items: limit)
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        @post = Post.friendly.find(params[:id])
      end
    end
  end
end
