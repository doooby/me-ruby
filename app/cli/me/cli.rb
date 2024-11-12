require "optparse"

module Me::Cli
  def self.run! args
    command = case args.shift.presence
    when "start", "t" then Me::CliCommands::Start
    when "list", "ls" then Me::CliCommands::List
    when "edit", "e" then Me::CliCommands::Edit
    when "-h", "--help"
      get_log_io(:out).puts HELP_MESSAGE
      Me::Cli.exit! 0
    else
      get_log_io(:out).puts <<-DOC
#{"bad command".red}

#{HELP_MESSAGE}
      DOC
      Me::Cli.exit! 1
    end

    command = command.new create_opt_parser
    command.parse! args
    command.process!
    Me::Cli.exit! 0
  end

  def self.create_opt_parser
    opt_parser = OptionParser.new
    opt_parser.on_tail("-h", "--help", "Prints this help") do
      get_log_io(:out).puts opt_parser
      Me::Cli.exit! 0
    end
    opt_parser
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

  # this is only for testing purposes, as it freezes the whole app at a specified time
  # use regular Time, as we use UTC internaly and we need current system time zone/time shift
  def self.set_now time
    @now_time = time
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
list, ls   list records
edit, e    edit a record
  DOC
end
