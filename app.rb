require 'rubygems'
require 'sinatra'
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'govuk_visual_regression'
require 'github_notifier'

set :bind, '0.0.0.0'

post '/run' do
  begin
    payload = JSON.parse(request.body.read)
  rescue JSON::ParserError
    status 400
  end

  environment = payload['deployment']['environment']
  review_domain = "https://#{environment}.herokuapp.com"
  live_domain = "https://#{environment.gsub(/\-pr\-\d+$/, '')}.herokuapp.com"
  surge_domain = "#{environment}.surge.sh"
  pull_request = environment.split('-').last

  GovukVisualRegression::VisualDiff::Runner.new(review_domain: review_domain).spider_component_guide
  paths = GovukVisualRegression::VisualDiff::SpiderPaths.component_preview_paths
  GovukVisualRegression::VisualDiff::HerokuRunner.new(paths: paths, review_domain: review_domain, live_domain: live_domain, surge_domain: surge_domain).run
  GitHubNotifier.new(pull_request, surge_domain).notify
end
