class Task < ApplicationRecord
  module Print
    TABLE_COLUMNS = %w[ id task start end text ]
    def self.tasks_to_table records, columns = TABLE_COLUMNS
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
  end

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

  module Attributes
    SHORTUCTS = {
      "i" => "id",
      "t" => "task",
      "m" => "message",
      "s" => "start",
      "e" => "end"
    }

    TABLE_MAP = {
      "message" => "text",
      "start" => "start_at",
      "end" => "end_at"
    }

    class InputError < StandardError; end

    def self.parse_input_pair input, task
      attr, raw_value = case input
      in /^(\w+)=(.+)$/
          [ $1, $2 ]
      else
          raise InputError, "bad format of `#{input}`"
      end

      attr = SHORTUCTS[attr] if SHORTUCTS.key? attr


      value = case attr
      when "id"
        raw_value.to_i
      when "task", "message"
        raw_value
      when "start"
        parse_time_input(
          raw_value,
          "" => Me::Cli.get_now,
          "_" => task.start_at&.getlocal
        )
      when "end"
        parse_time_input(
          raw_value,
          "" => Me::Cli.get_now,
          "_" => task.end_at&.getlocal,
          "s" => task.start_at&.getlocal
        )
      else
        raise InputError, "unknown attribute `#{attr}`"
      end

      [ attr, value ]
    end

    def self.parse_time_input value, **substitutions
      date_component, time_component = case value
      in /^(.*):(.*)$/
        [ $1, $2 ]
      else
        raise InputError, "bad format of date:time in `#{value}`"
      end

      substituted_keys = substitutions.keys

      date_parts = if substituted_keys.include? date_component
        date = substitutions[date_component]
        unless date
          raise InputError, "substituted date is nil in `#{date_component}`"
        end
        [ date.year, date.month, date.day ]
      elsif date_component.match(/^(\d\d)(\d\d)(\d\d)$/)
        date_parts = [ "20#{$1}".to_i, $2.to_i, $3.to_i ]
        if Date.valid_date?(*date_parts)
          date_parts
        else
          raise InputError, "bad date in `#{value}`"
        end
      else
        raise InputError, "bad date in `#{value}`"
      end

      time_parts = if substituted_keys.include? time_component
        time = substitutions[time_component]
        unless time
          raise InputError, "substituted time is nil in `#{time_component}`"
        end
        [ time.hour, time.min ]
      elsif time_component.match(/^(\d\d)(\d\d)$/)
        time_parts = [ $1.to_i, $2.to_i ]
        begin
          Time.new(*date_parts, *time_parts)
        rescue ArgumentError => _
          raise InputError, "bad time in `#{value}`"
        end
        time_parts
      else
        raise InputError, "bad time in `#{value}`"
      end

      Time.new(*date_parts, *time_parts)
    end

    def self.map_attrs_to_table_fields attrs
      fields = {}
      attrs.each do |attr, value|
        if TABLE_MAP.key? attr
          fields[TABLE_MAP[attr]] = value
        else
          fields[attr] = value
        end
      end
      fields
    end
  end
end
