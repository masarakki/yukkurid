require 'sinatra'

post '/' do
  if params[:message]
    yukkuri_bin = File.expand_path('../../bin/yukkuri', __FILE__)
    `echo #{params[:message]} | nkf -e | mecab -Oyomi | nkf -w | #{yukkuri_bin} |aplay -q`
  end
  ""
end
