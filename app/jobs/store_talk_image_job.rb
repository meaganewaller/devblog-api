# frozen_string_literal: true

require "open-uri"

# This job is used to download image from url and store it in ActiveStorage
class StoreTalkImageJob < ApplicationJob
  queue_as :default

  PERMIT_IMAGE_FORMAT = %w[png jpeg gif webp heic svg].freeze

  def perform(talk, image_url)
    Rails.logger.info("Storing image (#{image_url}) for talk: #{talk.title}")

    valid_image_format = get_content_type(image_url)

    uri = URI.parse(image_url)
    image = uri.open
    image_name = File.basename(image_url)
    talk.image.attach(io: image, filename: image_name, content_type: valid_image_format)
  end

  private

  def get_content_type(image_url)
    ext_name = File.extname(image_url).delete(".")

    "image/#{ext_name}"
  end
end
