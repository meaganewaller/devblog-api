# frozen_string_literal: true

namespace :server do
  desc %( ›› Run Rails while monitoring /app, /config )
  task start: :environment do
    sh %( rerun --dir config,app bin/rails s -p 5000 )
  end

  desc %( ›› Get the PID of the server )
  task :pid do
    sh %( more ./tmp/pids/server.pid )
  end

  desc %( ›› Kill -9 [:pid] )
  task :kill, [:pid] do |_t, args|
    @pid = args[:pid]
    sh %( set -e )
    sh %( kill -9 #{@pid} )
    sh %( rm -rf ./tmp/pids/server.pid )
  end

  desc %( ›› Remove rails detached server )
  task :remove_server do
    sh %( ps -aef | grep rails )
  end

  desc %( ›› Logger fix http://jerryclinesmith.me/blog/2014/01/16/logging-from-rake-tasks/ )
  task setup_logger: :environment do
    logger = Logger.new($stdout)
    logger.level = Logger::INFO
    Rails.logger = logger
  end
end
