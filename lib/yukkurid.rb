# -*- coding: utf-8 -*-
require 'sinatra'
require 'socket'
require 'nokogiri'
require 'haml'
require 'sass'
require 'yukkuri'
require 'redis'

def say(message, name)
  yukkuri_bin = File.expand_path('../../bin/yukkuri', __FILE__)
  aqtalk = Yukkuri::Message.new(message).aqtalk
  `echo "#{aqtalk}、#{name}" | #{yukkuri_bin} | aplay -q`
end

def redis
  @redis ||= Redis.new
end

def find_user(user_id)
  redis.get "yukkuri_user_#{user_id}"
end

def store_user(user_id, name)
  redis.set "yukkuri_user_#{user_id}", name
end

set :root, File.expand_path(File.dirname(__FILE__) + '/..')
set :markdown, :layout_engine => :haml

post '/listen_nicolive' do
  addr = params[:addr]
  port = params[:port].to_i
  thread = params[:thread].to_i

  puts "listen #{addr}:#{port}/#{thread}"
  socket = TCPSocket.new addr, port
  socket.sendmsg("<thread thread=\"#{thread}\" version=\"20061206\" res_from=\"-1\" />\0")
  loop {
    recv = socket.recvmsg
    xml = Nokogiri::XML(recv.first.strip)
    text = xml.text.strip
    unless text == ""
      user_id = xml.xpath("//@user_id").first
      user_id = user_id.value unless user_id.nil?

      if user_id && matches = text.match(/@(.+)/)
        store_user user_id, matches[1]
      end

      username = find_user(user_id)
      say(text, username)
    end
  }
end

get '/' do
  markdown :index
end

get '/style.css' do
  sass :style
end
