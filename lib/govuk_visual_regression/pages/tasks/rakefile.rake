require 'yaml'
require 'open-uri'
require "govuk_visual_regression/pages"

def paths
  YAML.load(open(ENV.fetch("URI")))
end

namespace :diff do
  desc 'produce visual diffs - set env var `URI` with location of a yaml file containing paths to diff'
  task visual: ['config:pre_flight_check'] do
    GovukVisualRegression::Pages::VisualDiff::Runner.new(paths: paths).run
  end

  desc "clears the results directory"
  task :clear_results do
    puts "---> Clearing results directory"
    require 'fileutils'
    FileUtils.remove_dir GovukVisualRegression::Pages.results_dir
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
