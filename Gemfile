source "https://rubygems.org"
ruby File.read(".ruby-version").chomp

gem "sinatra"
gem "wraith", "~> 4.0"
gem "govuk-lint", "~> 0.8"
gem "rake", "~> 10.0"
gem "rest-client"
gem "json"
gem "octokit", github: "octokit/octokit.rb"
gem "jwt"

# Yarn is only available to Ruby apps on Heroku with the webpacker gem
# https://devcenter.heroku.com/changelog-items/1114
gem "webpacker", require: false

group :development, :test do
  gem "rspec", "~> 3.6"
end

group :development do
  gem "pry-byebug"
end
