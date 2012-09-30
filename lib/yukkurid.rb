require 'sinatra'
require 'socket'
require 'nokogiri'
require 'haml'
require 'sass'
require 'yukkuri'

def say(message)
  yukkuri_bin = File.expand_path('../../bin/yukkuri', __FILE__)
  aqtalk = Yukkuri::Message.new(message).aqtalk
  `echo "#{aqtalk}" | #{yukkuri_bin} | aplay -q`
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
    text = Nokogiri::XML(recv.first.strip).text.strip
    say(text) unless text == ""
  }
end

get '/' do
  markdown :index
end

get '/style.css' do
  sass :style
end
