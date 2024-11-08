require 'rails_helper'

RSpec.describe 'Task::CliEdits' do
  describe '.parse_time_input' do
    def invoke! *args
      Task::CliEdits.parse_time_input *args
    end

    with_value '240101' do |value|
      expect(invoke! value).to eq('kkkk')
    end
  end
end
