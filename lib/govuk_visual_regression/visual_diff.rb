module GovukVisualRegression
  module VisualDiff
    autoload :Runner, 'govuk_visual_regression/visual_diff/runner'
    autoload :HerokuRunner, 'govuk_visual_regression/visual_diff/heroku_runner'
    autoload :WraithConfig, 'govuk_visual_regression/visual_diff/wraith_config'
    autoload :WraithSpiderComponentGuideConfig, 'govuk_visual_regression/visual_diff/wraith_spider_component_guide_config'
    autoload :DocumentTypes, 'govuk_visual_regression/visual_diff/document_types'
    autoload :SpiderPaths, 'govuk_visual_regression/visual_diff/spider_paths'
  end
end
