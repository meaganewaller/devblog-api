# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApiController
      def index
        @categories = if params["published_only"].present? && params["published_only"] == "true"
          Category.with_published_posts
        else
          Category.all
        end
      end

      def show
        @category = Category.friendly.find(params[:id])
      end
    end
  end
end
