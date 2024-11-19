require 'rails_helper'

RSpec.describe 'CLI: edit', type: :cli do
  after :each do
    Me::Cli.set_now nil
  end

  def invoke! value
    fake_cli! Me::CliCommands::Edit, value
  end

  with_value '' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: 1,
      stdout: <<-DOC
#{"missing TASK_ID".red}
      DOC
    })
  end

  with_value '999' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: 1,
      stdout: <<-DOC
#{"no task with id 999".red}
      DOC
    })
  end

  with_value '101 -at=ticket123' do |value|
    result = invoke! value
    expect(result).to eq({
      stdout: <<-DOC
│ id  │ task      │ start        │ end          │ text            │
├-----------------------------------------------------------------┤
│ 101   t1          240511:01:30   240511:03:00   Wash the dishes |
│ 101   ticket123   240511:01:30   240511:03:00   Wash the dishes |
└-----------------------------------------------------------------┘
      DOC
    })
  end
end
