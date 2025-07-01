require "optparse"

module Me::Cli
  def self.run! args
    command = case args.shift.presence
    when "start", "t" then Me::CliCommands::Start
    when "list", "ls" then Me::CliCommands::List
    when "edit", "e" then Me::CliCommands::Edit
    when "delete" then Me::CliCommands::Delete
    when "interactive" then Me::CliCommands::Interactive
    when "start_task" then Me::Commands::StartTask
    when "end" then Me::CliCommands::End
    when "-h", "--help"
      get_log_io(:out).puts HELP_MESSAGE
      Me::Cli.exit! 0
    else
      get_log_io(:out).puts "bad command".red
      get_log_io(:out).puts ""
      get_log_io(:out).puts HELP_MESSAGE
      Me::Cli.exit! 1
    end

    Me::Cli.freeze_now
    command.process!{ _1.parse! args }
    Me::Cli.exit! 0
  end

  def self.set_embeded_mode!
    @embeded_mode = {
      stdout: StringIO.new,
      stderr: StringIO.new
    }
  end

  def self.get_now
    @now_time || Time.now
  end

  # use regular Time, as we use UTC internaly and we need current system time zone/time shift
  def self.set_now time
    @now_time = time
  end

  def self.freeze_now
    set_now get_now
  end

  def self.unfreeze_now
    set_now nil
  end

  def self.exit! result
    if @embeded_mode
      raise ExitedException, "status: #{result}"
    else
      exit result
    end
  end

  def self.get_log_io output
    case output
    when :out
      @embeded_mode ? @embeded_mode[:stdout] : STDOUT
    when :err
      @embeded_mode ? @embeded_mode[:stderr] : STDERR
    else raise "ni: get_log_io #{output}"
    end
  end

  class ExitedException < StandardError; end

  HELP_MESSAGE = <<-DOC.strip
#{"Usage: me COMMAND [ARGS]".blue}

-- COMMANDS
start, t   adds new task record
start_task   adds new task record
list, ls   list records
edit, e    edit a record
end        end task
delete     delete a record
  DOC
end
