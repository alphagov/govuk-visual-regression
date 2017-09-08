module GovukVisualRegression
  module VisualDiff
    class HerokuRunner < Runner
      def install_surge
        @kernel.system "yarn global add surge"
      end

      def upload_to_surge
        @kernel.system "surge --project results/visual/ --domain govuk-vr.surge.sh"
      end

      def run
        install_surge
        super
        upload_to_surge
      end
    end
  end
end
