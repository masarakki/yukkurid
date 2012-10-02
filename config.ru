$:.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))
require 'yukkurid'

Yukkuri.setup do |conf|
  # conf.unidic = /path/to/unidic
end

run Sinatra::Application
