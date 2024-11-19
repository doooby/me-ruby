require 'rails_helper'

RSpec.describe 'Task::Attributes' do
  describe '.parse_time_input' do
    let(:point_in_time){ Time.new 2002, 2, 2, 2, 2 }

    def invoke! *args, **kwargs
      Task::Attributes.parse_time_input *args, **kwargs
    end

    with_value '%', '(invalid)' do |value|
      expect{ invoke! value }.to raise_error(
        Task::Attributes::InputError, 'bad format of date:time in `%`'
      )
    end

    with_value '240103:1516' do |value|
      expect(invoke! value).to eq(Time.new 2024, 1, 3, 15, 16)
    end

    with_value '240103:' do |value|
      subs = { '' => point_in_time }
      expect(invoke! value, **subs).to eq(Time.new 2024, 1, 3, 2, 2)
    end

    with_value ':1516' do |value|
      subs = { '' => point_in_time }
      expect(invoke! value, **subs).to eq(Time.new 2002, 2, 2, 15, 16)
    end

    with_value ':' do |value|
      subs = { '' => point_in_time }
      expect(invoke! value, **subs).to eq(Time.new 2002, 2, 2, 2, 2)
    end

    with_value '_:1516' do |value|
      subs = { '_' => point_in_time }
      expect(invoke! value, **subs).to eq(Time.new 2002, 2, 2, 15, 16)
    end

    with_value '_:1516', '(substitution is empty)' do |value|
      subs = { '_' => nil }
      expect{ invoke! value, **subs }.to raise_error(
        Task::Attributes::InputError, 'substituted date is nil in `_`'
      )
    end

    with_value '240103:_' do |value|
      subs = { '_' => point_in_time }
      expect(invoke! value, **subs).to eq(Time.new 2024, 1, 3, 2, 2)
    end

    with_value '240103:_', '(substitution is empty)' do |value|
      subs = { '_' => nil }
      expect{ invoke! value, **subs }.to raise_error(
        Task::Attributes::InputError, 'substituted time is nil in `_`'
      )
    end

    with_value '240103', '(missing time)' do |value|
      expect{ invoke! value }.to raise_error(
        Task::Attributes::InputError, 'bad format of date:time in `240103`'
      )
    end

    with_value '243103:0000', '(bad date)' do |value|
      expect{ invoke! value }.to raise_error(
        Task::Attributes::InputError, 'bad date in `243103:0000`'
      )
    end

    with_value '240103:2500', '(bad time)' do |value|
      expect{ invoke! value }.to raise_error(
        Task::Attributes::InputError, 'bad time in `240103:2500`'
      )
    end
  end
end
