require 'yaml'
require 'open-uri'
require "govuk_visual_regression"

def load_paths
  YAML.load(open(ENV.fetch("URI")))
end

namespace :diff do
  desc 'Set env var `URI` with location of a yaml file containing paths to diff'
  task visual: ['config:pre_flight_check'] do |_t, args|
    GovukVisualRegression::VisualDiff::Runner.new(paths: load_paths).run
  end

  desc 'Set env var `DOCUMENT_TYPE` to compare most popular documents'
  task document_type: ['config:pre_flight_check'] do |_t, args|
    document_type = ENV.fetch("DOCUMENT_TYPE")
    paths = GovukVisualRegression::VisualDiff::DocumentTypes.new.type_paths(document_type)

    GovukVisualRegression::VisualDiff::Runner.new(paths: paths).run
  end

  desc "clears the results directory"
  task :clear_results do
    puts "---> Clearing results directory"
    require 'fileutils'
    FileUtils.remove_dir GovukVisualRegression.results_dir
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

  desc "Checks that dependencies are in place on Heroku"
  task pre_flight_check_heroku: ['config:pre_flight_check'] do
    puts "Checking required packages available on Heroku"
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
end
