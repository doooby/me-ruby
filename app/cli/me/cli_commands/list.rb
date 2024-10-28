class Me::CliCommands::List < Me::CommandBase
  COLUMNS_TO_SHOW = %w[ id task start end text ]
  COLUMNS_TO_FILTER = %w[ id task start end text ]

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
      case value
      in /^(\d+)$/
        id = $1
        add_filter! "id", id
      in /^(\w+)=(.+)$/
        column, value = [ $1, $2 ]
        add_filter! column, value
      else
        raise ArgumentError, "invalid filter #{value}"
      end
    end
  end

  def parse! args
    _ = parser.parse args
  end

  def process
    scope = list_scope.order(id: :desc).limit(10)
    records = scope.to_a
    return if records.length.zero?

    columns = @show_columns || COLUMNS_TO_SHOW
    table = Me::CliCommands::List.tasks_to_table records, columns
    table.minimized = true if @minimize_output
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

  private

  def add_filter! column, value
    unless COLUMNS_TO_FILTER.include? column
      raise ArgumentError, "unknown column filter #{column}"
    end

    arel_attribute = Task.arel_table[column]
    condition = case column
    when "id", "task"
      arel_attribute.eq value
    when "text"
      arel_attribute.matches "%#{value}%"
    else
      raise ArgumentError, "unknown column filter #{column}"
    end
    @list_scope = list_scope.where condition
  end

  def list_scope
    @list_scope ||= Task.all
  end
end
