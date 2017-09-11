module GovukVisualRegression
  module VisualDiff
    class Runner
      def initialize(paths:, environment: nil, kernel: Kernel)
        @paths = paths
        @kernel = kernel
        @environment = environment
      end

      def run
        review_domain = @environment ? "https://#{@environment}.herokuapp.com" : nil
        wraith_config = WraithConfig.new(paths: @paths, review_domain: review_domain)
        wraith_config.write

        cmd = "wraith capture #{wraith_config.location}"
        puts "---> Creating Visual Diffs"
        puts "running: #{cmd}"
        @kernel.system cmd

        wraith_config.delete
      end
    end
  end
end
