require 'yaml'

module GovukVisualRegression
  module VisualDiff
    module SpiderPaths
      def self.paths
        YAML.load_file(GovukVisualRegression.spider_paths)['paths']
      end

      # Keep number of pages test down to a minimum
      # Only test component previews, not the guide itself
      # And only test the pages that show all previews on one page
      def self.component_preview_paths
        paths.values.select { |v| v.match(/preview$/) && v.split('/').length == 4 }
      end
    end
  end
end
