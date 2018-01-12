# Minimum viable visual regression testing of components
An app that wraps Wraith for automated visual regression testing that uploads generated galleries to surge.sh for manual review.

* A small sinatra app that runs on Heroku and listens to POST requests to `/run`
* When a Github webhook makes a request to `/run`, pull out the environment from the [deployment object](https://developer.github.com/v3/activity/events/types/#deploymentevent) and use it to set the domains for the wraith config
* Run an initial spider task that collects all the component preview URLs on the review app
* Use spider results to create wraith config and run regression against them
* Upload results to surge.sh using credentials in the environment
* Example output from Heroku logs: https://gist.github.com/fofr/20fc117011d6cc52a9a7defd880ec4cf
* Example gallery: http://government-frontend-pr-459.surge.sh/gallery.html

## Steps

* Raise PR, eg https://github.com/alphagov/government-frontend/pull/459
* Automatically deployed a review app: https://government-frontend-pr-459.herokuapp.com
* Triggers a Github deployment webhook on successful deploy with environment set to `government-frontend-pr-459`
* Run visual regression comparing https://government-frontend-pr-459.herokuapp.com/component-guide with https://government-frontend.herokuapp.com/component-guide
* Upload gallery to https://government-frontend-pr-459.surge.sh/gallery.html

## How to test locally

* Run app on VM using: `bundle exec ruby app.rb`
* App should be available at http://www.dev.gov.uk:4567/run

Fake a webhook, where `deployment_payload.json` is the file in 210c55a:
```
curl -X POST -d @deployment_payload.json http://www.dev.gov.uk:4567/run --header "Content-Type:application/json"
```

* Rake tasks are also available with REVIEW_DOMAIN and LIVE_DOMAIN environment variables

Part of:
https://trello.com/c/iXflEn6F/106-3-build-automated-visual-regression-proof-of-concept

Follow on from:

https://github.com/alphagov/government-frontend/pull/458
https://github.com/alphagov/government-frontend/pull/472
