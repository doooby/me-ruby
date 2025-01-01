class Me::CliCommands::Start < Me::CommandBase
  attr_accessor :task, :attributes

  def setup_parser
    parser.banner = "Usage: me start [OPTIONS]".blue

    parser.on("-tTASK", String, "task") do |value|
      attributes["task"] = value
    end

    parser.on("-mMESSAGE", String, "text message") do |value|
      attributes["message"] = value
    end

    parser.on("-aATTRIBUTE=VALUE", String, "attribute to set") do |input|
      attr, value = Task::Attributes.parse_input_pair input
      value = Task::Attributes.process_value(attr, value, task:)
      attributes[attr] = value
    end
  end

  def parse! args
    @task = Task.new
    @attributes = { "start" => Me::Cli.get_now }
    parse_args! args
  end

  def run
    task_attributes = Task::Attributes.map_attrs_to_table_fields attributes
    task.assign_attributes task_attributes
    task.save!

    table = Task::Print.tasks_to_table [ task ]
    table.each_text_row{ log :out, _1.strip }
  end
end
