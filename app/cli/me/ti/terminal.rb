module Me::Ti::Terminal
  class Settings
    attr_accessor :time_format
    def initialize
      set_humanized_time_format
    end
    def set_humanized_time_format
      @time_format = Proc.new do |time|
        day = time.day.to_s.rjust 2, " "
        month = time.month.to_s.rjust 2, " "
        "#{day}/#{month}/%y %H:%M"
      end
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
    time_format = settings.time_format
    time_format = time_format.call(time) if time_format.is_a? Proc
    time.localtime.strftime time_format
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
