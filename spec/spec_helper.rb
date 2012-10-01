require 'rubygems'
require 'spork'

Spork.prefork do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))

  require 'rspec'
  require 'yukkuri'

  RSpec.configure do |config|
  end

end

Spork.each_run do
end
