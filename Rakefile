require 'rake'

port = 9999

namespace :server do
  desc 'start server'
  task :start do
    `rackup -p #{port} -D --pid rack.pid`
  end

  desc 'stop server'
  task :stop do
    pid = `cat rack.pid`.strip
    `kill -INT #{pid}` unless pid == ""
  end

  desc 'restart server'
  task :restart do
    Rake::Task['stop'].invoke
    Rake::Task['start'].invoke
  end
end
