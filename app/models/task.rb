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
          raise CliEdits::InvalidInputError, "bad format of `#{input}`"
      end

      value = case attr
      when "task", "text"
        raw_value
      when "start"
        parse_time_input(
          raw_value,
          "" => Me::Cli.get_now,
          "_" => task.start_time.getlocal
        )
      # when "end"
      #   parse_end_time_input raw_value, task
      else
        raise CliEdits::InvalidInputError, "unknown attribute `#{attr}`"
      end

      [ attr, value ]
    end

    def self.parse_time_input value, **substitutions
      date_component, time_component = case value
      in /^(.*):(.*)$/
        [ $1, $2 ]
      else
        raise CliEdits::InvalidInputError, "bad format of date:time in `#{value}`"
      end

      substituted_keys = substitutions.keys

      date_parts = if substituted_keys.include? date_component
        date = substitutions[date_component]
        unless date
          raise CliEdits::InvalidInputError, "substituted date is nil in `#{date_component}`"
        end
        [ date.year, date.month, date.day ]
      elsif date_component.match(/^(\d\d)(\d\d)(\d\d)$/)
        date_parts = [ "20#{$1}".to_i, $2.to_i, $3.to_i ]
        if Date.valid_date?(*date_parts)
          date_parts
        else
          raise CliEdits::InvalidInputError, "bad date in `#{value}`"
        end
      else
        raise CliEdits::InvalidInputError, "bad date in `#{value}`"
      end

      time_parts = if substituted_keys.include? time_component
        time = substitutions[time_component]
        unless time
          raise CliEdits::InvalidInputError, "substituted time is nil in `#{time_component}`"
        end
        [ time.hour, time.min ]
      elsif time_component.match(/^(\d\d)(\d\d)$/)
        time_parts = [ $1.to_i, $2.to_i ]
        begin
          Time.new(*date_parts, *time_parts)
        rescue ArgumentError => _
          raise CliEdits::InvalidInputError, "bad time in `#{value}`"
        end
        time_parts
      else
        raise CliEdits::InvalidInputError, "bad time in `#{value}`"
      end

      Time.new(*date_parts, *time_parts)
    end

    class InvalidInputError < StandardError; end
  end
end
