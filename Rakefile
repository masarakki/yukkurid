require 'rake'

port = 9999

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

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

task :default => :spec
