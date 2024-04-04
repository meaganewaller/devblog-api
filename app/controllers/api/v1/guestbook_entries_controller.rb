# frozen_string_literal: true

module Api
  module V1
    # GuestbookEntriesController - API for GuestbookEntries
    class GuestbookEntriesController < ApiController
      def index
        @entries = GuestbookEntry.approved
        limit = if params[:limit].present?
                  params[:limit].to_i
                else
                  10
                end
        @pagy, @entries = pagy(@entries, items: limit)
        @pagy_metadata = pagy_metadata(@pagy)
      end

      def create
        @entry = GuestbookEntry.new(guestbook_entry_params)
        if @entry.valid?
          @entry.save
          render :show, status: :created
        else
          render json: @entry.errors, status: :unprocessable_entity
        end
      end

      private

      def guestbook_entry_params
        params.require(:guestbook_entry).permit(:name, :email, :body, :session_id, :website)
      end
    end
  end
end
