require 'yaml'

module GovukVisualRegression
  module VisualDiff
    class WraithConfig
      attr_reader :location
      attr_reader :paths
      attr_reader :review_domain
      attr_reader :live_domain

      def initialize(paths: [], review_domain: nil, live_domain: nil)
        @paths = paths
        @live_domain = live_domain
        @review_domain = review_domain
        @location = GovukVisualRegression.config_file(temporary_config_file_name)
      end

      def config
        config = YAML.load_file(GovukVisualRegression.wraith_config_template)
        config["paths"] = paths.each_with_object({}) do |path, hash|
          hash[path_config_name(path)] = path unless path_would_break_wraith?(path)
        end

        config["domains"]["live"] = live_domain if live_domain
        config["domains"]["review"] = review_domain if review_domain
        config
      end

      def yaml_config
        YAML.dump(config)
      end

      def write
        wraith_config = File.new(location, "w")
        wraith_config.write(yaml_config)
        wraith_config.tap(&:close)
      end

      def delete
        File.unlink(location)
      end

      # TODO: Remove when Wraith patched
      # Paths containing "path" in them break Wraith:
      # https://github.com/BBC-News/wraith/issues/536
      def path_would_break_wraith?(path)
        path.include?('path')
      end

      def path_config_name(path)
        path.gsub('/', '_')
      end

      def temporary_config_file_name
        "tmp_wraith_config.yaml"
      end
    end
  end
end
