# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApiController
      before_action :set_commentable
      before_action :set_comment, only: %i[show update destroy]

      # GET /post/:post_id/comments
      # GET /projects/:project_id/comments
      # GET /workspaces/workspace_id/comments
      # GET /comments/:comment_id/comments
      def index
        @comments = @commentable.comments
        render json: @comments
      end

      # POST /posts/:post_id/comments
      # POST /projects/:project_id/comments
      # POST /workspaces/:workspace_id/comments
      def create
        @comment = @commentable.comments.new(comment_params)
        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # GET /comments/:id
      def show
        render json: @comment
      end

      # PATCH/PUT /comments/:id
      def update
        if @comment.update(comment_params)
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # DELETE /comments/:id
      def destroy
        @comment.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_commentable
        @commentable = find_commentable
      end

      def set_comment
        @comment = Comment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def comment_params
        params.require(:comment).permit(:content, :author_name, :author_email, :author_website, :notify_by_email)
      end

      def find_commentable
        # Use a case statement to determine the commentable type based on the params
        if params[:post_id]
          Post.find(params[:post_id])
        elsif params[:project_id]
          Project.find(params[:project_id])
        elsif params[:workspace_id]
          Workspace.find(params[:workspace_id])
        end
      end
    end
  end
end
