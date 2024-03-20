# frozen_string_literal: true

module Api
  module V1
    class ViewsController < ApiController
      before_action :find_existing_view, only: %i[create]

      def index
        @views = View.where(viewable_type: params[:viewable_type])
        @views = @views.where(viewable_slug: params[:viewable_slug]) if params[:viewable_slug].present?
        @views = @views.where(session_id: params[:session_id]) if params[:session_id].present?
      end

      def create
        return render json: { status: 'OK', data: { view: @existing_view } }, status: :ok if @existing_view
        @view = View.new(view_params)

        if @view.save
          render json: { status: 'SUCCESS', message: 'View created', data: @view }, status: :created
        else
          render json: { status: :unprocessable_entity, message: 'Error',  data: @view.errors },
                 status: :unprocessable_entity
        end
      end

      private

      def find_existing_view
        @existing_view = View.where(view_params).first
      end

      def view_params
        params.require(:view).permit(:viewable_slug, :viewable_type, :session_id)
      end
    end
  end
end
