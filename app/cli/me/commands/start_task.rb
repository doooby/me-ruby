class Me::Commands::StartTask < Me::Command
  attr_accessor :task, :attributes

  def setup_parser
    parser.banner = "Usage: me start_task TASK [GOAL] [OPTIONS]".blue

    parser.on("-aATTRIBUTE=VALUE", String, "attribute to set") do |input|
      attr, value = Task::Attributes.parse_input_pair input
      value = Task::Attributes.process_value(attr, value, task:)
      attributes[attr] = value
    end
  end

  def parse! args
    @task = Task.new
    @attributes = { "start" => Me::Cli.get_now }
    @task_value = args.shift.presence unless args.first&.start_with? "-"
    @goal_value = args.shift.presence unless args.first&.start_with? "-"
    super
  end

  def load_now
    unless @task_value
      log :out, <<-DOC
#{"missing TASK".red}
      DOC
      Me::Cli.exit! 1
    end
  end

  def run
    attributes["task"] = @task_value
    attributes["message"] = @goal_value if @goal_value
    task_attributes = Task::Attributes.map_attrs_to_table_fields attributes
    task.assign_attributes task_attributes
    task.save!

    table = Task::Print.tasks_to_table [ task ]
    table.each_text_row{ log :out, _1.strip }
  end
end
