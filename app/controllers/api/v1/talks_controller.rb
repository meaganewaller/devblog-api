# frozen_string_literal: true

module Api
  module V1
    class TalksController < ApiController
      def index
        all_talks = Talk.includes([:category], [:image_attachment])
        @talks = if params[:recent]
                   all_talks.limit(3)
                 else
                   all_talks
                 end

        if params[:category].present? && !params[:recent]
          @talks = @talks.includes([:category]).filter_by_category(params[:category])
        end

        @talks = @talks.filter_by_tag(params[:tag]) if params[:tag].present? && !params[:recent]
        @talks = @talks.search_post(params[:query]) if params[:query].present? && !params[:recent]

        limit = if params[:limit].present?
                  params[:limit].to_i
                else
                  10
                end

        limit = params[:recent] ? 3 : limit

        @pagy, @talks = pagy(@talks, items: limit)
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        @talk = Talk.friendly.find(params[:id])
      end
    end
  end
end
