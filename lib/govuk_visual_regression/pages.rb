module GovukVisualRegression
  module Pages
    autoload :VisualDiff, 'govuk_visual_regression/pages/visual_diff'

    def self.root_dir
      File.dirname __dir__
    end

    def self.results_dir
      File.expand_path(root_dir + "/../results")
    end

    def self.wraith_config_template
      config_file 'wraith.yaml'
    end

    def self.config_file(filename)
      File.expand_path(root_dir + "/../config/#{filename}")
    end
  end
end
