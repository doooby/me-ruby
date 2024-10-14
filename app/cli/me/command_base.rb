class Me::CommandBase
  attr_accessor :parser

  def initialize opt_parser
    @parser = opt_parser
    setup_parser
  end

  def process!
    process
  rescue => error
    log :out, <<-DOC
#{"fail".red}
    DOC
    log :err, error.message
    log :err, error.backtrace.join("\n")
    Me::Cli.exit! 1
  end

  def log output, message
    Me::Cli.get_log_io(output).puts message.strip
  end
end
