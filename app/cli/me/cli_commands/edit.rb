class Me::CliCommands::Edit < Me::CommandBase
  attr_accessor :task, :new_attributes

  def setup_parser
    parser.banner = "Usage: me edit TASK_ID [OPTIONS]".blue

    parser.on("-aATTR=VAL", String, "records attribute to set") do |value|
      attr, value = Task::CliEdits.parse_attr_value value, task
      new_attributes[attr] = value
    end
  end

  def parse! args
    task_id = args.shift.presence
    unless task_id
      log :out, <<-DOC
#{"missing TASK_ID".red}
      DOC
      Me::Cli.exit! 1
    end

    @task = Task.find_by id: task_id
    unless task
      log :out, <<-DOC
#{"no task with id  #{task_id}".red}
      DOC
      Me::Cli.exit! 1
    end

    @new_attributes = {}
    _ = parser.parse args
  end

  def process
    puts new_attributes
    raise "niy"
    # task = Task.create!(start_at: Me::Cli.get_now, task: task_name, text:)

    # columns = Me::CliCommands::List.sanitize_columns_list %w[ id task start text ]
    # table = Me::CliCommands::List.tasks_to_table [ task ], columns
    # table.minimized = true
    # table.each_text_row{ log :out, _1.strip.green }
  end
end
