#\ --pid rack.pid
$:.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))
require 'yukkurid'
run Sinatra::Application
