# frozen_string_literal: true
module Api
  module V1
    class PostReactionsController < ApiController
      # GET /api/v1/posts/:post_id/reactions
      def index
        post = Post.friendly.find(params[:post_id])
        reactions = post.reactions

        render json: reactions, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Post not found' }, status: :not_found
      end

      def create
        post = Post.friendly.find(params[:post_id])
        reaction = post.reactions.build(reaction_params)

        if reaction.save
          render json: reaction, status: :created
        else
          render json: { errors: reaction.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Post not found' }, status: :not_found
      end

      private

      def reaction_params
        params.require(:reaction).permit(:kind)
      end
    end
  end
end
