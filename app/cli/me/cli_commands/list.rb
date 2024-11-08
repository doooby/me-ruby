class Me::CliCommands::List < Me::CommandBase
  COLUMNS_TO_SHOW = %w[ id task start end text ]

  attr_accessor :scope, :show_columns, :minimize_output

  def setup_parser
    parser.banner = "Usage: me list [OPTIONS]".blue

    parser.on("-cLIST", String, "columns to show (default: #{COLUMNS_TO_SHOW.join ","})") do |list|
      list = list.split ","
      @show_columns = Me::CliCommands::List.sanitize_columns_list list
    end

    parser.on("-m", String, "minimize output") do |value|
      @minimize_output = true
    end

    parser.on("-fCOL=VAL", String, "filter recrods (`-f 42`, `-ftask=me5`)") do |value|
      column, value = Task::CliFilters.parse_column_value value
      @scope = Task::CliFilters.apply scope, column, value
    end
  end

  def parse! args
    @show_columns = COLUMNS_TO_SHOW
    @scope = Task.all
    _ = parser.parse args
  end

  def process
    records = scope.order(id: :desc).limit(10).to_a
    return if records.length.zero?

    table = Me::CliCommands::List.tasks_to_table records, show_columns
    table.minimized = true if minimize_output
    table.each_text_row{ log :out, _1.strip }
  end

  def self.sanitize_columns_list list
    COLUMNS_TO_SHOW && list
  end

  def self.tasks_to_table records, columns
    rows = records.map do |record|
      columns.map do |column|
        case column
        when "id" then record.id
        when "task" then record.task.to_s
        when "text" then record.text.to_s
        when "start" then Me::Terminal.format_time record.start_at
        when "end" then Me::Terminal.format_time record.end_at
        end
      end
    end
    Me::Terminal::DataTable.new rows, columns
  end
end
