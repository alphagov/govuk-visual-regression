require 'yaml'

module GovukVisualRegression
  module VisualDiff
    module SpiderPaths
      def self.paths
        YAML.load_file(GovukVisualRegression.spider_paths)['paths']
      end

      # Only test component previews, not the guide itself
      def self.component_preview_paths
        paths.values.select { |v| v.match(/preview$/) }
      end
    end
  end
end
