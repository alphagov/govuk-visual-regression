module GovukVisualRegression
  module VisualDiff
    class HerokuRunner < Runner
      def install_surge
        @kernel.system "yarn global add surge"
      end

      def upload_to_surge
        surge_domain = @environment ? @environment : "govuk-vr"
        @kernel.system "surge --project results/visual/ --domain #{surge_domain}.surge.sh"
      end

      def run
        install_surge
        super
        upload_to_surge
      end
    end
  end
end
