class Me::CliCommands::List < Me::CommandBase
  KNOWN_COLUMNS = %w[ index id task start end text ]

  def setup_parser
    parser.banner = "Usage: me list [OPTIONS]".blue

    parser.on("-cLIST", String, "columns to show (default: #{KNOWN_COLUMNS.join ","})") do |list|
      list = list.split ","
      @show_columns = KNOWN_COLUMNS && list
    end

    parser.on("-m", String, "minimize output") do |value|
      @minimize_output = true
    end

    parser.on("-fCOL=VAL", String, "filter recrods (`-f 42`, `-f -1`, `-ftask=me5`)") do |value|
      @filters ||= {}
      result = value.match %r{^(\w+)=(.+)$}
      unless result
        raise "invalid filter `#{value}`"
      end
      @filters[result[1]] = result[2]
    end
  end

  def parse! args
    _ = parser.parse args
  end

  def process
    scope = Task.all
    scope = scope.order id: :desc
    scope = scope.limit 10
    records = scope.to_a
    return if records.length.zero?

    columns = @show_columns || KNOWN_COLUMNS
    table = Me::CliCommands::List.tasks_to_table records, columns
    table.minimized = true if @minimize_output
    table.each_text_row{ log :out, _1 }
  end

  def self.tasks_to_table records, columns
    rows = records.map.with_index do |record, record_index|
      columns.map.with_index do |column, column_index|
        case column
        when "index" then (- record_index) - 1
        when "id" then record.id
        when "task" then record.task.to_s
        when "text" then record.text.to_s
        when "start" then format_time record.start_at
        when "end" then format_time record.end_at
        end
      end
    end
    Me::Terminal::DataTable.new rows, columns
  end

  def self.format_time time
    return "" unless time
    time.localtime.strftime "%y%m%d:%H:%M"
  end
end
