class Me::CliCommands::End < Me::CommandBase
  attr_accessor :id, :task, :end_at

  def setup_parser
    parser.banner = "Usage: me end TASK_ID END_AT".blue
  end

  def parse! args
    @id = args.shift.presence
    @end_at = args.shift.presence
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

    if task.end_at
      table = Task::Print.tasks_to_table [ task ]
      table.each_text_row{ log :out, _1.strip }
      log :out, <<-DOC
#{"task already ended".red}
      DOC
      Me::Cli.exit! 1
    end

    unless @end_at
      log :out, <<-DOC
#{"missing END_AT".red}
      DOC
      Me::Cli.exit! 1
    end
    begin
      @end_at = Task::Attributes.process_value "end", @end_at
    rescue InputError => e
      log :out, e.message.red
      Me::Cli.exit! 1
    end
  end

  def run
    original_task = Task.find task.id
    task.end_at = end_at
    task.save!

    table = Task::Print.tasks_to_table [ original_task, task ]
    table.each_text_row{ log :out, _1.strip }
  end
end
