class Me::CliCommands::Start < Me::CommandBase
  attr_accessor :task_name, :text

  def setup_parser
    parser.banner = "Usage: me start TASK_NAME [OPTIONS]".blue

    parser.on("-tMESSAGE", String, "text message") do |value|
      @text = value
    end
  end

  def parse! args
    @task_name = args.shift
    if task_name.blank?
      log :out, <<-DOC
#{"missing TASK_NAME".red}
      DOC
      Me::Cli.exit! 1
    end

    _ = parser.parse args
  end

  def process
    task = Task.create!(start_at: Me::Cli.get_now, task: task_name, text:)

    columns = Me::CliCommands::List.sanitize_columns_list %w[ id task start text ]
    table = Me::CliCommands::List.tasks_to_table [ task ], columns
    table.minimized = true
    table.each_text_row{ log :out, _1.strip.green }
  end
end
