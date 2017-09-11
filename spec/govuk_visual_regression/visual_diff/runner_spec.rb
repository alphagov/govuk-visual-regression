describe GovukVisualRegression::VisualDiff::Runner do
  describe "#run" do
    let(:kernel) { double }
    let(:input_paths) { FixtureHelper.load_paths_from("test_paths.yaml") }
    let(:config_handler_klass) { GovukVisualRegression::VisualDiff::WraithConfig }
    let(:config_handler) { config_handler_klass.new(paths: input_paths, review_domain: 'review') }

    before do
      allow(config_handler_klass).to receive(:new).and_return(config_handler)
      allow(config_handler).to receive_messages(write: nil, delete: nil)
      allow(kernel).to receive(:system)
    end

    it "executes wraith with the appropriate config" do
      expect(config_handler_klass).to receive(:new).with(paths: ["/government/stats/foo", "/government/stats/bar"], review_domain: 'review', live_domain: nil)
      expect(config_handler).to receive(:write)
      expect(kernel).to receive(:system).with("wraith capture #{config_handler.location}")
      expect(config_handler).to receive(:delete)

      expect { described_class.new(paths: input_paths, review_domain: 'review', kernel: kernel).run }.to output(
        "---> Creating Visual Diffs\n" +
        "running: wraith capture #{config_handler.location}\n"
      ).to_stdout
    end
  end
end
