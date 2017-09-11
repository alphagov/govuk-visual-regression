require 'rubygems'
require 'sinatra'
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'govuk_visual_regression'
set :bind, '0.0.0.0'

post '/run' do
  begin
    payload = JSON.parse(request.body.read)
  rescue JSON::ParserError
    status 400
  end

  environment = payload['deployment']['environment']
  review_domain = "https://#{environment}.herokuapp.com"

  paths = GovukVisualRegression::VisualDiff::DocumentTypes.new.type_paths('statistics')
  GovukVisualRegression::VisualDiff::Runner.new(paths: paths, review_domain: review_domain).run
end
