require "optparse"

module Me::Cli
  def self.run! args
    command = case args.shift.presence
    when "start", "t" then Me::CliCommands::Start
    when "-h", "--help"
      puts HELP_MESSAGE
      exit
    else
      puts <<-DOC
#{"bad command".red}

#{HELP_MESSAGE}
      DOC
      exit 1
    end

    opt_parser = OptionParser.new
    opt_parser.on_tail("-h", "--help", "Prints this help") do
      puts opt_parser
      exit
    end

    command = command.new opt_parser
    command.parse! args
    command.process
  end

  HELP_MESSAGE = <<-DOC.strip
#{"Usage: me COMMAND [ARGS]".blue}

-- COMMANDS
start, t    adds new task record
  DOC
end
