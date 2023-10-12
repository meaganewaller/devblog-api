# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApiController
      def index
        if params[:recent]
          @posts = Post.includes([:category]).published.limit(5)
        else
          @posts = Post.includes([:category]).published
        end
        @posts = @posts.filter_by_category(params[:category]) if params[:category].present?
        @posts = @posts.filter_by_tag(params[:tag]) if params[:tag].present?
        @posts = @posts.search_post(params[:query]) if params[:query].present?

        items = params[:limit] || params[:recent] ? 5 : 10

        @pagy, @posts = pagy(@posts, items:)
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        @post = Post.friendly.find(params[:id])
      end
    end
  end
end
