module Api
  module V1
    class CategoriesController < ApiController
      def index
        if params["published_only"].present? && params["published_only"] == 'true'
          @categories = Category.with_published_posts
        else
          @categories = Category.all
        end
      end

      def show
        @category = Category.friendly.find(params[:id])
      end
    end
  end
end
