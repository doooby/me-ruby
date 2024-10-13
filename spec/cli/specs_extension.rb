require 'shellwords'

RSpec.configure do |config|
  module CliHelper
    extend RSpec::SharedContext

    let(:cli_path) { Rails.root.join "bin/cli.rb" }

    def cli! command
      stdout, stderr, status = Open3.capture3 "#{cli_path} #{command}"
      { stdout:, stderr:, status: }
    end

    def fake_cli! command_klass, command_args
      Me::Cli.set_embeded_mode!
      command = command_klass.new Me::Cli.create_opt_parser
      command.parse! Shellwords.split(command_args)
      command.process!
      Me::Cli.exit! 0
    rescue Me::Cli::ExitedException => exception
      {
        exit: exception.message,
        stdout: Me::Cli.get_log_io(:out).string,
        stderr: Me::Cli.get_log_io(:err).string
      }
    ensure
      Me::Cli.instance_variable_set "@embeded_mode", nil
    end

    def expect_these_tasks record_checks
      records = Task.all.to_a
      records.each_with_index do |record, index|
        if index >= record_checks.count
          raise "unexpected record index=#{index}"
        end
        record_checks[index].call record
      end
      if records.count < record_checks.count
        raise "expected #{record_checks.count} records, got only #{records.count}"
      end
    end
  end

  config.include CliHelper, type: :cli
end
