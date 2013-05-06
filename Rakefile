$:.unshift 'lib'
require 'rake'
require 'yukkuri'
require 'fileutils'

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
    `kill -KILL #{pid}` unless pid == ""
  end

  desc 'restart server'
  task :restart do
    Rake::Task['server:stop'].invoke
    Rake::Task['server:start'].invoke
  end
end

namespace :unidic do
  dirname = Yukkuri::Message.unidic_dir

  desc 'install'
  task :install do

    FileUtils.rm_r(dirname) if File.exists?(dirname)
    filename = "unidic.zip"
    url = "http://sourceforge.jp/frs/redir.php?m=jaist&f=%2Funidic%2F58338%2Funidic-mecab-2.1.2_bin.zip"
    system "wget", "-O", filename, url
    system "unzip", "-j", "-d", dirname, filename

    File.open(File.join(dirname, 'dicrc'), 'a+') do |file|
      file.puts ''
      file.puts 'node-format-yukkuri = %m\t%f[9]\t%f[0]\t%f[23]\t%f[24]\n'
      file.puts 'unk-format-yukkuri  = %m\t%m\t%f[0]\t0\t0\n'
      file.puts 'bos-format-yukkuri  ='
      file.puts 'eos-format-yukkuri  ='
    end

    File.unlink filename
  end

  desc 'clean'
  task :clean do
    FileUtils.rm_r(dirname) if File.exists?(dirname)
  end
end

task :default => :spec
