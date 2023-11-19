# frozen_string_literal: true

namespace :rspec do
  desc "›› Rspec run all specs"
  task all: :environment do
    sh %( bundle exec rspec )
  end

  desc "›› Rspec run only model specs"
  task model: :environment do
    sh %( bundle exec rspec spec/models )
  end

  desc "›› Rspec run only request specs"
  task requests: :environment do
    sh %( bundle exec rspec spec/requests )
  end

  desc "›› Rspec run only job specs"
  task jobs: :environment do
    sh %( bundle exec rspec spec/jobs )
  end
end
