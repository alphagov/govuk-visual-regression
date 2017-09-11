require 'yaml'
require 'securerandom'

module GovukVisualRegression
  module VisualDiff
    class WraithConfig
      attr_reader :location

      def initialize(paths:)
        @paths = paths
        @location = GovukVisualRegression.config_file("tmp_wraith_config.yaml")
      end

      def write
        config_template = YAML.load_file GovukVisualRegression.wraith_config_template
        wraith_formatted_paths = @paths.each_with_object({}) do |path, hash|
          hash[SecureRandom.uuid] = path unless path_would_break_wraith?(path)
        end
        config_template["paths"] = wraith_formatted_paths
        wraith_config = File.new(location, "w")
        wraith_config.write(YAML.dump config_template)
        wraith_config.tap(&:close)
      end

      def delete
        File.unlink location
      end

      # TODO: Remove when Wraith patched
      # Paths containing "path" in them break Wraith:
      # https://github.com/BBC-News/wraith/issues/536
      def path_would_break_wraith?(path)
        path.include?('path')
      end
    end
  end
end
