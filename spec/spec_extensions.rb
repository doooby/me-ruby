require 'shellwords'

RSpec.configure do |config|
  module CliHelper
    extend RSpec::SharedContext

    let(:cli_path){ Rails.root.join "bin/cli.rb" }

    def run_cli! command
      stdout, stderr, status = Open3.capture3 "#{cli_path} #{command}"
      { stdout:, stderr:, status: }
    end

    def fake_cli! command, command_args
      Me::Cli.set_embeded_mode!
      command.process! do |instance|
        instance.parse! Shellwords.split(command_args)
      end
      Me::Cli.exit! 0
    rescue Me::Cli::ExitedException => exception
      exit_status = exception.message[-1].to_i
      stderr = Me::Cli.get_log_io(:err).string.presence
      result = {
        stdout: Me::Cli.get_log_io(:out).string
      }
      result[:exit] = exit_status unless exit_status.zero?
      result[:stderr] = stderr if stderr
      result
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


  module DescibreScopeHelper
    def with_value value, message = nil, &block
      case_label = [
        "`#{value}`".yellow,
        (" #{message}" if message)
      ].compact.join('')
      it case_label do
        instance_exec value, &block
      end
    end
  end
  config.extend DescibreScopeHelper
end
