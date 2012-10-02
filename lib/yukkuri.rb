module Yukkuri
  autoload :Message, 'yukkuri/message'
  autoload :Config, 'yukkuri/config'

  def config
    @config ||= Config.new
  end

  def setup(&block)
    yield(config)
  end

  extend self
end
