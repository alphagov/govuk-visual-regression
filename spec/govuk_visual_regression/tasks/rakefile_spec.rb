require "spec_helper"
require "rspec/core/rake_task"
load "./lib/govuk_visual_regression/tasks/rakefile.rake"

RSpec.describe "rakefile" do
  before do
    ENV.stub(:fetch).with("URI").and_return(FixtureHelper.locate("test_paths.yaml"))
  end

  describe "diff:visual" do
    it "invokes GovukVisualRegression::HtmlDiff::Runner with right parameters" do
      mocked_runner = double(GovukVisualRegression::VisualDiff::Runner, run: true)

      expect(GovukVisualRegression::VisualDiff::Runner).to receive(:new)
        .with(paths: %w(/government/stats/foo /government/stats/bar))
        .and_return(mocked_runner)

      Rake::Task["diff:visual"].invoke
    end
  end
end
