# frozen_string_literal: true

module Api
  module V1
    class ContactController < ApplicationController
      def create
        @contact = Api::V1::CreateContactEntry.call(contact_params)
        if @contact
          render json: { message: 'Contact created successfully' }, status: :created
        else
          render json: { message: 'Contact not created' }, status: :unprocessable_entity
        end
      end

      private

      def contact_params
        params.require(:contact).permit(:name, :email, :subject, :message)
      end
    end
  end
end
