# frozen_string_literal: true

return unless defined?(StrongMigrations)

# Start after 2019-09-20 00:00:00 - after first migration with initial db tables creation
StrongMigrations.start_after = 20_230_601_000_000

StrongMigrations.auto_analyze = true

ActiveRecord::Base.dump_schema_after_migration =
  Rails.env.development? &&
  `git status db/migrate/ --porcelain`.present?
