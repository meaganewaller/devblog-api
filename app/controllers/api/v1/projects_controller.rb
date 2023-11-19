# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApiController
      def index
        @projects = Project.all
        @projects = @projects.filter_by_language(params[:language]) if params[:language].present?
        @projects = @projects.filter_by_tag(params[:tag]) if params[:tag].present?

        @pagy, @projects = pagy(@projects, items: 25)
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        @project = Project.friendly.find(params[:id])
      end
    end
  end
end
