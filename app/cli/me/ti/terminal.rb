module Me::Ti::Terminal
  class Settings
    attr_accessor :time_format
    def initialize
      set_humanized_time_format
    end
    def set_humanized_time_format
      @time_format = "%-d/%-m/%y %H:%M"
    end
    def set_strict_time_format
      @time_format = "%y%m%d:%H:%M"
    end
  end

  def self.string_length string
    string
      .gsub(/(\e\[[\d;]*m)/, "")
      .length
  end

  def self.format_time time, settings
    return "" unless time
    time.localtime.strftime settings.time_format
  end

  def self.parse_time text, relative_date: nil
    relative_date = relative_date&.to_time
    case text
    in /^(\d{6}|now)?:(\d\d?):(\d\d?)$/
      date, hour, min = [ $1, $2, $3 ]
      date = relative_date || "now" if date.nil?
      case date
      when "now"
        begin
          Me::Cli.get_now.change hour:, min:
        rescue ArgumentError
          raise ArgumentError, "invalid time #{hour}:#{min}"
        end
      when String
        year, month, day = date.scan %r{\d\d}
        begin
          Time.new "20#{year}", month, day, hour, min
        rescue ArgumentError
          raise ArgumentError, "invalid time #{text}"
        end
      when Time
        begin
          date.change hour:, min:
        rescue ArgumentError
          raise ArgumentError, "invalid time #{hour}:#{min} at realtive: #{date}"
        end
      else
        raise ArgumentError, "invalid date [#{date.class}]:#{date.inspect}"
      end
    else
      raise ArgumentError, "invalid time #{text}"
    end
  end

  class DataTable
    attr_reader :rows, :columns
    attr_accessor :minimized

    def initialize rows, columns
      @rows = rows.each do |row|
        row.map!{ _1.to_s }
      end
      @columns = columns
    end

    def each_text_row
      column_sizes = columns.map.with_index do |column, index|
        items_max = rows
          .map{ Me::Ti::Terminal.string_length _1[index] }
          .max
        [ items_max, minimized ? 0 : column.length ].max
      end

      table_row = nil
      unless minimized
        header = +"│ "
        columns.each_with_index do |text, index|
          header << " │ " unless index.zero?
          Me::Ti::Terminal.push_cell_into! header, text, column_sizes[index]
        end
        header << " │"
        yield header

        table_row = +"├"
        chars = 1 + column_sizes.sum + (column_sizes.length * 3) - 1
        table_row << ("-"  * chars)
        table_row[-1] = "┤"
        yield table_row
      end

      rows.each_with_index do |row, row_index|
        text = minimized ? +"" : +"│ "
        separator = minimized ? " " : "   "
        columns.length.times do |index|
          text << separator unless index.zero?
          Me::Ti::Terminal.push_cell_into! text, row[index], column_sizes[index]
        end
        text << " |" unless minimized
        yield text, row_index
      end

      unless minimized
        table_row[0] = "└"
        table_row[-1] = "┘"
        yield table_row
      end
    end
  end

  # takes a astring and pushes a cell text into it, with required padding
  # to make each cell of given column same size
  def self.push_cell_into! string, text, cell_size
    padd = cell_size - text.length
    string << text
    string << (" " * padd) if padd > 0
  end
end
