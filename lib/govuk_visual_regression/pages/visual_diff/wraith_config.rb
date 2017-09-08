require 'yaml'
require 'securerandom'

module GovukVisualRegression
  module Pages
    module VisualDiff
      class WraithConfig
        attr_reader :location

        def initialize(paths:)
          @paths = paths
          @location = GovukVisualRegression::Pages.config_file("tmp_wraith_config.yaml")
        end

        def write
          config_template = YAML.load_file GovukVisualRegression::Pages.wraith_config_template
          wraith_formatted_paths = @paths.each_with_object({}) do |path, hash|
            hash[SecureRandom.uuid] = path
          end
          config_template["paths"] = wraith_formatted_paths
          wraith_config = File.new(location, "w")
          wraith_config.write(YAML.dump config_template)
          wraith_config.tap(&:close)
        end

        def delete
          File.unlink location
        end
      end
    end
  end
end
