if Rails.env.development? || Rails.env.test?
  # This introduces the `table` statement
  # rubocop:disable Style/MixinUsage
  extend Hirb::Console
  # rubocop:enable Style/MixinUsage
end
