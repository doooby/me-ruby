class Me::CliCommands::List < Me::CommandBase
  attr_reader :scope, :show_columns, :minimize_output

  def setup_parser
    parser.banner = "Usage: me list [OPTIONS]".blue

    parser.on("-cLIST", String, "columns to show (default: #{Task::Print::TABLE_COLUMNS.join ","})") do |list|
      list = list.split ","
      @show_columns = Me::CliCommands::List.sanitize_columns_list list
    end

    parser.on("-m", String, "minimize output") do |value|
      @minimize_output = true
    end

    parser.on("-fATTRIBUTE=VALUE", String, "filter recrods (`-f 42`, `-ftask=me5`)") do |input|
      attr, value = Task::Attributes.parse_input_pair input
      value = Task::Attributes.process_value attr, value
      @scope = Task.all.filter_by_attr_value attr, value
    end

    parser.on("--per VALUE", String, "set pagination records per page") do |value|
      if value == "all"
        @pagination = {
          **pagination,
          per: nil
        }
      elsif per_page = value.match(/^(\d*)$/)
        @pagination = {
          **pagination,
          per: per_page[1].to_i
        }
      end
    end
  end

  def parse! args
    @show_columns = Task::Print::TABLE_COLUMNS
    @scope = Task.all
    super
  end

  def pagination
    @pagination ||= {
      per: 10
    }
  end

  def run
    @scope = scope.order(id: :desc)

    pagination[:per] = pagination[:per] || 9999
    pagination[:per] = 100 if pagination[:per] > 100
    @scope = scope.limit pagination[:per]
    puts "pagition=#{pagination}"

    records = scope.to_a
    return if records.length.zero?

    table = Task::Print.tasks_to_table records, columns: show_columns
    table.minimized = true if minimize_output
    table.each_text_row{ log :out, _1.strip }
  end

  def self.sanitize_columns_list list
    Task::Print::TABLE_COLUMNS && list
  end
end
