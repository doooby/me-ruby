class Me::CommandBase
  attr_accessor :parser

  def initialize opt_parser
    @parser = opt_parser
    try :setup_parser
  end

  def self.process!
    opt_parser = OptionParser.new
    opt_parser.on_tail("-h", "--help", "Prints this help") do
      Me::Cli.get_log_io(:out).puts opt_parser
      Me::Cli.exit! 0
    end
    instance = new opt_parser
    yield instance
    instance.process!
  end

  def parse! args
    parse_args! args
  end

  def process!
    try :load_now
    run
  rescue => error
    log :out, <<-DOC
#{"fail".red}
    DOC
    log :err, error.message
    log :err, error.backtrace.join("\n")
    Me::Cli.exit! 1
  end

  def parse_args! args
    parser.parse args
  end

  def log output, message
    Me::Cli.get_log_io(output).puts message
  end
end
