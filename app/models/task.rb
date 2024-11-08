class Task < ApplicationRecord
  module CliFilters
    COLUMNS = %w[ id task text ]

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
      unless CliFilters::COLUMNS.include? column
        raise CliFilters::Error, "unknown column #{column}"
      end

      arel_attribute = Task.arel_table[column]
      condition = case column
      when "id", "task"
        arel_attribute.eq value
      when "text"
        arel_attribute.matches "%#{value}%"
      end
      scope.where condition
    end

    class Error < StandardError; end
  end

  module CliEdits
    ATTRIBUTES = %w[ task text start end ]

    def self.parse_attr_value input
      attr, raw_value = case input
      in /^(\w+)=(.+)$/
          [ $1, $2 ]
      else
          raise ClieEdits::Error, "invalid input #{input}"
      end

      unless CliEdits::ATTRIBUTES.include? attr
        raise CliEdits::Error, "unknown attribute #{attr}"
      end

      value = case attr
      when "task", "text"
        raw_value
      when "start", "end"
        parse_time_input raw_value
      end

      [ attr, value ]
    end

    def self.parse_time_input value
      raise "niy"
    end

    class Error < StandardError; end
  end
end
