module GovukVisualRegression
  module VisualDiff
    class WraithSpiderComponentGuideConfig < WraithConfig
      def config
        config = YAML.load_file(GovukVisualRegression.wraith_config_template)
        config["domains"].delete("live")
        config["domains"]["review"] = "#{review_domain}/component-guide" if review_domain

        # http://bbc-news.github.io/wraith/#Spiderfunctionality
        config["imports"] = "spider_paths.yml"

        # Skip pages that don't begin with /component-guide
        config["spider_skips"] = [/^\/(?!component\-guide)/]
        config.delete("paths")
        config
      end

      def temporary_config_file_name
        "tmp_wraith_spider_component_guide_config.yaml"
      end
    end
  end
end
