module Api
  module V1
    class MetricsController < ApplicationController
      def index
        @wakatime_data = ::MetricsApi.default_wakatime_api
        @metrics = Post.published
      end

      def show
        @post = Post.friendly.find(params[:id])
      end
    end
  end
end
