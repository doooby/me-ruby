class Me::CliCommands::Start < Me::CommandBase
  attr_accessor :task_name, :text

  def setup_parser
    parser.banner = "Usage: me start TASK_NAME [TEXT]".blue
  end

  def parse! args
    @task_name, @text, *_ = parser.parse args
    if task_name.blank?
      log :out, <<-DOC
#{"missing TASK_NAME".red}
      DOC
      Me::Cli.exit! 1
    end
  end

  def process
    Task.create!(start_at: Time.now, task: task_name, text:)

    log :out, <<-DOC
#{"DONE".green}
    DOC
  end
end
