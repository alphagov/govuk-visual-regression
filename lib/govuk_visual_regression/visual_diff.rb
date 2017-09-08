module GovukVisualRegression
  module VisualDiff
    autoload :Runner, 'govuk_visual_regression/visual_diff/runner'
    autoload :HerokuRunner, 'govuk_visual_regression/visual_diff/heroku_runner'
    autoload :WraithConfig, 'govuk_visual_regression/visual_diff/wraith_config'
    autoload :DocumentTypes, 'govuk_visual_regression/visual_diff/document_types'
  end
end
