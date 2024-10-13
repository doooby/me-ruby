class Me::CliCommands::List < Me::CommandBase
  # attr_accessor :task_name, :text

  def setup_parser
    parser.banner = "Usage: me list [OPTIONS]".blue
  end

  def parse! args
    _ = parser.parse args
    #     @task_name, @text, *_ = parser.parse args
    #     if task_name.blank?
    #       log :out, <<-DOC
    # #{"missing TASK_NAME".red}
    #       DOC
    #       Me::Cli.exit! 1
    #     end
  end

  def process
    scope = Task.all
    scope = scope.order id: :desc
    scope = scope.limit 10
    records = scope.to_a

    rows = [
      %w[ row ID task start end text ]
    ]
    records.each_with_index do |record, index|
      rows.push [
        (-1 * (index + 1)).to_s,
        record.id.to_s,
        record.task.to_s,
        record.start_at.to_s,
        record.end_at.to_s,
        record.text.to_s
      ]
    end

    print_table rows, true unless rows.first.blank?
  end

  def print_table rows, header
    sizes = Array.new(rows.first.length) { 0 }
    rows.each_with_index do |row, row_index|
      sizes.length.times do |column_index|
        cell = row[column_index]
        puts "cell[#{row_index}:#{column_index}] #{cell}"
        sizes[column_index] = cell.length if cell.length > sizes[column_index]
      end
    end
    rows.each_with_index do |row, row_index|
      items = []
      sizes.each_with_index do |column_size, column_index|
        text = row[column_index]
        padd = column_size - text.length
        items.push text + (" " * padd)
      end
      row_text = items.join(
        header && row_index.zero? ? " | " : "   "
      )
      puts row_text
    end
  end
end
