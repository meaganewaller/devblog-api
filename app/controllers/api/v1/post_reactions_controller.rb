# frozen_string_literal: true

module Api
  module V1
    class PostReactionsController < ApiController
      # GET /api/v1/posts/:post_id/reactions
      def index
        post = Post.friendly.find(params[:post_id])
        @reactions = post.reactions
        @user_reactions = @reactions.where(session_id: params[:session_id]) if params[:session_id]
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Post not found"}, status: :not_found
      end

      def create
        post = Post.friendly.find(params[:post_id])
        @reaction = post.reactions.build(reaction_params)

        if @reaction.save
          render json: {status: "SUCCESS", message: "Reaction created", data: @reaction}, status: :created
        else
          render json: {errors: @reaction.errors.full_messages}, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Post not found"}, status: :not_found
      end

      private

      def reaction_params
        params.require(:reaction).permit(:kind, :session_id)
      end
    end
  end
end
