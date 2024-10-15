module Me::Terminal
  def self.format_time time
    return "" unless time
    time.localtime.strftime "%y%m%d:%H:%M"
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
        items_max = rows.map{ _1[index].length }.max
        [ items_max, minimized ? 0 : column.length ].max
      end

      unless minimized
        header = String.new "│ "
        columns.each_with_index do |text, index|
          header << " │ " unless index.zero?
          Me::Terminal.push_cell_into! header, text, column_sizes[index]
        end
        header << " │"
        yield header

        header_separator = String.new "├"
        chars = 1 + column_sizes.sum + (column_sizes.length * 3) - 1
        header_separator << ("-"  * chars)
        yield header_separator

      end

      rows.each do |row|
        text = minimized ? String.new : String.new("│ ")
        separator = minimized ? " " : "   "
        columns.length.times do |index|
          text << separator unless index.zero?
          Me::Terminal.push_cell_into! text, row[index], column_sizes[index]
        end
        yield text
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
