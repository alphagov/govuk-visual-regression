require 'yaml'
require 'open-uri'
require "govuk_visual_regression"

def load_paths
  YAML.load(open(ENV.fetch("URI")))
end

def review_domain
  ENV.fetch("REVIEW_DOMAIN")
end

def live_domain
  ENV.fetch("LIVE_DOMAIN")
end

namespace :diff do
  desc 'Set env var `URI` with location of a yaml file containing paths to diff'
  task visual: ['config:pre_flight_check'] do |_t, args|
    GovukVisualRegression::VisualDiff::Runner.new(paths: load_paths, review_domain: review_domain, live_domain: live_domain).run
  end

  desc 'Set env var `DOCUMENT_TYPE` to compare most popular documents'
  task document_type: ['config:pre_flight_check'] do |_t, args|
    document_type = ENV.fetch("DOCUMENT_TYPE")
    paths = GovukVisualRegression::VisualDiff::DocumentTypes.new.type_paths(document_type)

    GovukVisualRegression::VisualDiff::Runner.new(paths: paths).run
  end

  desc 'Set env var `REVIEW_DOMAIN` to the domain hosting the newer component guide and `LIVE_DOMAIN` to compare with'
  task component_guide: ['spider:component_guide'] do |_t, args|
    paths = GovukVisualRegression::VisualDiff::SpiderPaths.component_preview_paths
    if paths.any?
      GovukVisualRegression::VisualDiff::Runner.new(paths: paths, review_domain: review_domain, live_domain: live_domain).run
    else
      puts "No paths found"
    end
  end

  desc "clears the results directory"
  task :clear_results do
    puts "---> Clearing results directory"
    require 'fileutils'
    FileUtils.remove_dir GovukVisualRegression.results_dir
  end
end

namespace :spider do
  desc 'Set env var `REVIEW_DOMAIN` to the domain hosting the component guide'
  task component_guide: ['config:pre_flight_check'] do |_t, args|
    GovukVisualRegression::VisualDiff::Runner.new(review_domain: review_domain).spider_component_guide
  end
end

namespace :config do
  desc "Checks that dependencies are in place"
  task :pre_flight_check do
    puts "Checking required packages installed."
    dependencies_present = true
    { imagemagick: 'convert', phantomjs: 'phantomjs' }.each do |package, binary|
      print "#{package}..... "
      result = %x[ which #{binary} ]
      if result.empty?
        puts "Not found"
        dependencies_present = false
      else
        puts "OK"
      end
    end
    unless dependencies_present
      abort("ERROR: A required dependency is not installed")
    end
  end
end

namespace :heroku do
  desc "Checks that dependencies are in place on Heroku"
  task pre_flight_check: ['config:pre_flight_check'] do
    dependencies_present = true
    { yarn: 'yarn' }.each do |package, binary|
      print "#{package}..... "
      result = %x[ which #{binary} ]
      if result.empty?
        puts "Not found"
        dependencies_present = false
      else
        puts "OK"
      end
    end
    unless dependencies_present
      abort("ERROR: A required dependency is not installed")
    end
  end

  # desc "Install surge for uploading visual regression results"
  # task install_surge: ['heroku:pre_flight_check'] do
  #   surge_available = %x[ which surge ]
  #   exec("yarn global add surge") unless surge_available
  # end

  desc 'Set env var `DOCUMENT_TYPE` to compare most popular documents'
  task document_type: ['heroku:pre_flight_check'] do |_t, args|
    document_type = ENV.fetch("DOCUMENT_TYPE")
    paths = GovukVisualRegression::VisualDiff::DocumentTypes.new.type_paths(document_type)
    GovukVisualRegression::VisualDiff::HerokuRunner.new(paths: paths).run
  end
end
