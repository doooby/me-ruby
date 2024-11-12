require 'rails_helper'

RSpec.describe 'Task::CliEdits' do
  describe '.parse_start_time_input' do
    after :each do
      Me::Cli.set_now nil
    end

    let(:point_in_time){ Time.new 2002, 2, 2, 2, 2 }

    def invoke! *args
      Task::CliEdits.parse_start_time_input *args
    end

    with_value '%', '(invalid)' do |value|
      expect{ invoke! value, nil }.to raise_error(
        Task::CliEdits::Error, 'invalid date:time input %'
      )
    end

    with_value '240103:1516' do |value|
      expect(invoke! value, nil).to eq(Time.new 2024, 1, 3, 15, 16)
    end

    with_value '240103:' do |value|
      Me::Cli.set_now point_in_time
      expect(invoke! value, nil).to eq(Time.new 2024, 1, 3, 2, 2)
    end

    with_value ':1516' do |value|
      Me::Cli.set_now point_in_time
      expect(invoke! value, nil).to eq(Time.new 2002, 2, 2, 15, 16)
    end

    with_value ':' do |value|
      Me::Cli.set_now point_in_time
      expect(invoke! value, nil).to eq(Time.new 2002, 2, 2, 2, 2)
    end

    with_value '_:1516' do |value|
      expect(invoke! value, point_in_time).to eq(Time.new 2002, 2, 2, 15, 16)
    end

    with_value '_:1516', '(current is empty)' do |value|
      expect{ invoke! value, nil }.to raise_error(
        Task::CliEdits::Error, 'invalid date:time input _:1516 - current attribute is empty'
      )
    end

    with_value '240103:_' do |value|
      expect(invoke! value, point_in_time).to eq(Time.new 2024, 1, 3, 2, 2)
    end

    with_value '240103:_', '(current is empty)' do |value|
      expect{ invoke! value, nil }.to raise_error(
        Task::CliEdits::Error, 'invalid date:time input 240103:_ - current attribute is empty'
      )
    end

    with_value '240103', '(missing time)' do |value|
      expect{ invoke! value, nil }.to raise_error(
        Task::CliEdits::Error, 'invalid date:time input 240103'
      )
    end

    with_value '243103:0000', '(bad date)' do |value|
      expect{ invoke! value, nil }.to raise_error(
        Task::CliEdits::Error, 'invalid date:time input 243103:0000 - bad date'
      )
    end

    with_value '240103:2500', '(bad time)' do |value|
      expect{ invoke! value, nil }.to raise_error(
        Task::CliEdits::Error, 'invalid date:time input 240103:2500 - bad time'
      )
    end
  end
end
