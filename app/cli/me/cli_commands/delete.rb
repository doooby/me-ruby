class Me::CliCommands::Delete < Me::CommandBase
  attr_accessor :id, :task

  def setup_parser
    parser.banner = "Usage: me delete TASK_ID".blue
  end

  def parse! args
    @id = args.shift.presence unless args.first&.start_with? "-"
    super
  end

  def load_now
    return if @task

    unless @id
      log :out, <<-DOC
#{"missing TASK_ID".red}
      DOC
      Me::Cli.exit! 1
    end

    @task = Task.find_by id: @id
    unless task
      log :out, <<-DOC
#{"no task with id #{@id}".red}
      DOC
      Me::Cli.exit! 1
    end
  end

  def run
    task.destroy!

    table = Task::Print.tasks_to_table [ task ]
    table.each_text_row{ log :out, _1.strip }
  end
end
