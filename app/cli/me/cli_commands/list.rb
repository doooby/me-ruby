class Me::CliCommands::List < Me::CommandBase
  attr_accessor :scope, :show_columns, :minimize_output

  def setup_parser
    parser.banner = "Usage: me list [OPTIONS]".blue

    parser.on("-cLIST", String, "columns to show (default: #{Task::Print::TABLE_COLUMNS.join ","})") do |list|
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
    @show_columns = Task::Print::TABLE_COLUMNS
    @scope = Task.all
    _ = parser.parse args
  end

  def process
    records = scope.order(id: :desc).limit(10).to_a
    return if records.length.zero?

    table = Task::Print.tasks_to_table records, show_columns
    table.minimized = true if minimize_output
    table.each_text_row{ log :out, _1.strip }
  end

  def self.sanitize_columns_list list
    Task::Print::TABLE_COLUMNS && list
  end
end
