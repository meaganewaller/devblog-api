module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        @projects = Project.all
        @projects = @projects.filter_by_language(params[:language]) if params[:language].present?
        @projects = @projects.filter_by_tag(params[:tag]) if params[:tag].present?
      end

      def show
        @project = Project.friendly.find(params[:id])
      end
    end
  end
end
