RSpec.configure do |config|
  module CliSpecsExtension
    extend RSpec::SharedContext

    let(:cli_path) { Rails.root.join "bin/cli.rb" }

    def cli! command
      stdout, stderr, status = Open3.capture3 "#{cli_path} #{command}"
      { stdout:, stderr:, status: }
    end
  end

  config.include CliSpecsExtension, type: :cli
end
