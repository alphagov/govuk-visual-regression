module GovukVisualRegression
  module VisualDiff
    class HerokuRunner < Runner
      def initialize(paths: [], review_domain: nil, live_domain: nil, surge_domain: nil, kernel: Kernel)
        @paths = paths
        @kernel = kernel
        @review_domain = review_domain
        @live_domain = live_domain
        @surge_domain = surge_domain
      end

      def install_surge
        @kernel.system "yarn install"
      end

      def upload_to_surge
        @kernel.system "yarn surge --project results/visual/ --domain #{@surge_domain}"
      end

      def run
        install_surge
        super
        upload_to_surge
      end
    end
  end
end
