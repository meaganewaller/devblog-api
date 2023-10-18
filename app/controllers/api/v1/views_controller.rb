# frozen_string_literal: true

module Api
  module V1
    class ViewsController < ApiController
      def index
        @views = View.where(viewable_type: params[:viewable_type])
        @views = @views.where(viewable_slug: params[:viewable_slug]) if params[:viewable_slug].present?
        @views = @views.where(session_id: params[:session_id]) if params[:session_id].present?
      end

      def show
        @view = View.find(params['id'])
      end

      def create
        @existing_view = View.where(view_params)

        if @existing_view
          render json: { status: 'OK', data: { view: @existing_view } }, status: :ok
        else
          @view = View.new(view_params)
          if @view.save
            render json: { status: 'SUCCESS', message: 'View created', data: @view }, status: :created
          else
            render json: @view.errors, status: :unprocessable_entity
          end
        end
      end

      private

      def view_params
        params.require(:view).permit(:viewable_slug, :viewable_type, :session_id)
      end
    end
  end
end
