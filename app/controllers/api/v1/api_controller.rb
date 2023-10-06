module Api
  module V1
    class ApiController < ActionController::API
      include ActAsApiRequest
      include Pagy::Backend
    end
  end
end
