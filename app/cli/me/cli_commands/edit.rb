class Me::CliCommands::Edit < Me::CommandBase
  attr_accessor :task, :attributes

  def setup_parser
    parser.banner = "Usage: me edit TASK_ID [OPTIONS]".blue

    parser.on("-aATTRIBUTE=VALUE", String, "attribute to set") do |input|
      attr, value = Task::Attributes.parse_input_pair input
      value = Task::Attributes.process_value(attr, value, task:)
      attributes[attr] = value
    end
  end

  def parse! args
    unless args[0] == "-h" || args[0] == "--help"
      load args.shift.presence
    end
    @attributes = {}
    _ = parser.parse args
  end

  def load task_id
    unless task_id
      log :out, <<-DOC
#{"missing TASK_ID".red}
      DOC
      Me::Cli.exit! 1
    end

    @task = Task.find_by id: task_id
    unless task
      log :out, <<-DOC
#{"no task with id #{task_id}".red}
      DOC
      Me::Cli.exit! 1
    end
  end

  def process
    original_task = Task.find task.id
    task_attributes = Task::Attributes.map_attrs_to_table_fields attributes
    task.assign_attributes task_attributes
    task.save!

    table = Task::Print.tasks_to_table [ original_task, task ]
    table.each_text_row{ log :out, _1.strip }
  end
end
