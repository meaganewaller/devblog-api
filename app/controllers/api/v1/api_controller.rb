# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      include ActAsApiRequest
      include Pagy::Backend

      private

      def verified_request?
        if request.content_type == 'application/json' && request.original_url.include?(ENV.fetch('CLIENT_ORIGIN_URL'))
          true
        else
          super()
        end
      end
    end
  end
end
