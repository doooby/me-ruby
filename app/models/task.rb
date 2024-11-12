class Task < ApplicationRecord
  module CliFilters
    def self.parse_column_value filter
      case filter
      in /^(\d+)$/
          id = $1
          [ "id", id ]
      in /^(\w+)=(.+)$/
          [ $1, $2 ]
      else
          raise CliFilters::Error, "invalid filter #{filter}"
      end
    end

    def self.apply scope, column, value
      condition = case column
      when "id", "task"
        Task.arel_table[column].eq value
      when "text"
        Task.arel_table[column].matches "%#{value}%"
      else
        raise CliFilters::Error, "unknown column #{column}"
      end
      scope.where condition
    end

    class Error < StandardError; end
  end

  module CliEdits
    def self.parse_attr_value input, task
      attr, raw_value = case input
      in /^(\w+)=(.+)$/
          [ $1, $2 ]
      else
          raise CliEdits::Error, "invalid attribute input #{input}"
      end

      value = case attr
      when "task", "text"
        raw_value
      when "start"
        parse_start_time_input raw_value, task.start_time
      when "end"
        parse_end_time_input raw_value, task
      else
        raise CliEdits::Error, "unknown attribute #{attr}"
      end

      [ attr, value ]
    end

    def self.parse_start_time_input value, relative_time
      date_component, time_component = case value
      in /^(.*):(.*)$/
        [ $1, $2 ]
      else
        raise CliEdits::Error, "invalid date:time input #{value}"
      end

      time_now = Me::Cli.get_now
      original_time = relative_time&.getlocal

      date_parts = case date_component
      in /^$/
        [ time_now.year, time_now.month, time_now.day ]
      in /^_$/
        unless original_time
          raise CliEdits::Error, "invalid date:time input #{value} - current attribute is empty"
        end
        [ original_time.year, original_time.month, original_time.day ]
      in /^(\d\d)(\d\d)(\d\d)$/
        date_parts = [ "20#{$1}".to_i, $2.to_i, $3.to_i ]
        if Date.valid_date?(*date_parts)
          date_parts
        else
          raise CliEdits::Error, "invalid date:time input #{value} - bad date"
        end
      else
        raise CliEdits::Error, "invalid date:time input #{value}  - bad date"
      end

      time_parts = case time_component
      in /^$/
        [ time_now.hour, time_now.min ]
      in /^_$/
        unless original_time
          raise CliEdits::Error, "invalid date:time input #{value} - current attribute is empty"
        end
        [ original_time.hour, original_time.min ]
      in /^(\d\d)(\d\d)$/
        time_parts = [ $1.to_i, $2.to_i ]
        begin
          Time.new(*date_parts, *time_parts)
        rescue ArgumentError => _
          raise CliEdits::Error, "invalid date:time input #{value} - bad time"
        end
        time_parts
      else
        raise CliEdits::Error, "invalid date:time input #{value} - bad time"
      end

      Time.new(*date_parts, *time_parts)
    end

    class Error < StandardError; end
  end
end
