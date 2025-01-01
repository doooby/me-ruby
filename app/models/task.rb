class Task < ApplicationRecord
  module Print
    TABLE_COLUMNS = %w[ id task start end message ]
    def self.tasks_to_table records, columns: TABLE_COLUMNS, settings: Me::Ti::Terminal::Settings.new
      rows = records.map do |record|
        columns.map do |column|
          case column
          when "i", "id" then record.id
          when "t", "task" then record.task.to_s
          when "m", "message" then record.text.to_s
          when "s", "start" then Me::Ti::Terminal.format_time record.start_at, settings
          when "e", "end" then
            end_at = record.end_at
            value = if end_at
              Me::Ti::Terminal.format_time end_at, settings
            else
              "in progress ".yellow
            end
            "-> #{value}"
          end
        end
      end
      Me::Ti::Terminal::DataTable.new rows, columns
    end
  end

  def self.filter_by_attr_value attr, value
    condition = case attr
    when "id", "task"
      Task.arel_table[attr].eq value
    when "message"
      Task.arel_table["text"].matches "%#{value}%"
    else
      raise Attributes::NotSpecifiedError, "cannot filter by #{attr}"
    end
    where condition
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
    class NotSpecifiedError < StandardError; end

    def self.parse_input_pair input
      attr, value = case input
      in /^(\d+)/
        [ "id", $1 ]
      in /^(\w+)=(.+)$/
        [ $1, $2 ]
      else
        raise InputError, "bad format of `#{input}`"
      end

      attr = SHORTUCTS[attr] if SHORTUCTS.key? attr
      [ attr, value ]
    end

    def self.process_value attr, raw_value, task: nil
      case attr
      when "id"
        raw_value.to_i
      when "task", "message"
        raw_value.to_s
      when "start"
        parse_time_input(
          raw_value,
          "" => Me::Cli.get_now,
          "_" => task&.start_at&.getlocal
        )
      when "end"
        parse_time_input(
          raw_value,
          "" => Me::Cli.get_now,
          "_" => task&.end_at&.getlocal,
          "s" => task&.start_at&.getlocal
        )
      else
        raise InputError, "unknown attribute `#{attr}`"
      end
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

  module Import
    def self.import lines
      if lines.is_a? String
        lines = lines
          .split("\n")
          .map(&:presence)
          .compact
      end

      lines.each do |line|
        record = Version_0_9.parse_line line
        record.save!
      end
    end

    module Version_0_9
      def self.parse_line text
        words = []
        4.times do
          word, text = unshift_word text
          words.push word
        end
        date = words[0]
        Task.new({
          start_at: build_date(date, words[1]),
          end_at: build_date(date, words[2]),
          task: words[3],
          text: text
        })
      end

      def self.unshift_word text
        text = text.strip
        index = text.index " "
        if index and rest = text[index..-1].strip.presence
          word = text[0..index - 1]
          [ word, rest ]
        else
          [ text, nil ]
        end
      end

      def self.build_date date, time
        Time.new(
          2000 + date[0..1].to_i,
          date[2..3].to_i,
          date[4..5].to_i,
          time[0..1].to_i,
          time[3..4].to_i,
          0
        )
      end
    end
  end
end
