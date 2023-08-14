module Api
  module V1
    class PostsController < ApplicationController
      def index
        @posts = Post.includes([:category]).published
        @posts = @posts.filter_by_category(params[:category]) if params[:category].present?
        @posts = @posts.filter_by_tag(params[:tag]) if params[:tag].present?
      end

      def show
        @post = Post.friendly.find(params[:id])
      end
    end
  end
end
