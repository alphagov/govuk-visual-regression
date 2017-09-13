module GovukVisualRegression
  module VisualDiff
    class Runner
      def initialize(paths: [], review_domain: nil, live_domain: nil, kernel: Kernel)
        @paths = paths
        @kernel = kernel
        @review_domain = review_domain
        @live_domain = live_domain
      end

      def spider_component_guide
        wraith_config = WraithSpiderComponentGuideConfig.new(review_domain: @review_domain)
        wraith_config.write

        cmd = "wraith spider #{wraith_config.location}"
        puts "---> Running component guide spider on #{@review_domain}"
        puts "running: #{cmd}"
        @kernel.system cmd
      end

      def run
        wraith_config = WraithConfig.new(paths: @paths, review_domain: @review_domain, live_domain: @live_domain)
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
