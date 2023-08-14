namespace :test do
  desc "›› Drop test database"
  task drop: :environment do
    raise 'You cannot run this in production' if Rails.env.production?
    sh %{ bin/rails db:drop RAILS_ENV=test }
  end

  desc "›› Create test database"
  task create: :environment do
    raise 'You cannot run this in production' if Rails.env.production?
    sh %{ bin/rails db:create RAILS_ENV=test }
  end

  desc "›› Load test database"
  task load: :environment do
    raise 'You cannot run this in production' if Rails.env.production?
    sh %{ bin/rails db:schema:load RAILS_ENV=test }
  end

  desc "›› Seed database"
  task seed: :environment do
    raise 'You cannot run this in production' if Rails.env.production?
    sh %{ bin/rails db:seed RAILS_ENV=test }
  end

  desc "›› Wipe test database"
  task wipe: :environment do
    raise 'You cannot run this in production' if Rails.env.production?
    sh %{ bin/rails db:purge db:create db:migrate db:seed RAILS_ENV=test }
  end
end
