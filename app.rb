require 'rubygems'
require 'sinatra'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
set :bind, '0.0.0.0'

post '/run' do
  begin
    payload = JSON.parse(request.body.read)
  rescue JSON::ParserError
    status 400
  end

  puts request.body
  puts payload
end
