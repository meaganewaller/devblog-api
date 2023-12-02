# frozen_string_literal: true

module Api
  module V1
    class WorkspacesController < ApiController

      def index
        @workspaces = Workspace.all

        @pagy, @workspaces = pagy(@workspaces, items: 5)
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def show
        @workspace = Workspace.friendly.find(params[:id])
      end
    end
  end
end
