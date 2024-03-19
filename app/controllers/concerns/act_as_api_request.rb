# frozen_string_literal: true

module ActAsApiRequest
  extend ActiveSupport::Concern

  included do
    before_action :check_request_type
  end

  def check_request_type
    return if request_body.empty?

    allowed_types = %w[json form-data]
    content_type = request.content_type

    return if content_type.match(Regexp.union(allowed_types))

    render json: { error: I18n.t('errors.invalid_content_type') }, status: :bad_request
  end

  private

  def request_body
    request.body.read
  end
end
