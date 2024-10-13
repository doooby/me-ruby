class Me::CliCommands::Start
  attr_accessor :opt_parser, :task_name, :text

  def initialize opt_parser
    @opt_parser = opt_parser
    opt_parser.banner = "Usage: me start TASK_NAME [TEXT]".blue
  end

  def parse! args
    @task_name, @text, *_ = opt_parser.parse args
    if task_name.blank?
      puts <<-DOC
#{"missing TASK_NAME".red}

#{opt_parser.to_s.strip}
      DOC
      exit 1
    end
  end

  def process
    puts [ task_name, text ].inspect
  end
end
