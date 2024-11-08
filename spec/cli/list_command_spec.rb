require 'rails_helper'

RSpec.describe 'CLI: list', type: :cli do
  fixtures :tasks

  def invoke! value
    fake_cli! Me::CliCommands::List, value
  end

  with_value '' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
│ id  │ task │ start        │ end          │ text                   │
├--------------------------------------------------------------------
│ 106   t6     240813:02:00   240813:04:00   Mow the lawn
│ 105   t5     240601:21:00   240601:22:00   Clean the bathroom
│ 104   t4     240416:05:00   240416:05:30   Take out the trash
│ 103   t3     240702:22:30   240703:00:30   Do the laundry
│ 102   t2     240320:21:00   240320:22:30   Vacuum the living room
│ 101   t1     240511:01:30   240511:03:00   Wash the dishes
      DOC
      stderr: ""
    })
  end

  with_value '-m' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
106 t6 240813:02:00 240813:04:00 Mow the lawn
105 t5 240601:21:00 240601:22:00 Clean the bathroom
104 t4 240416:05:00 240416:05:30 Take out the trash
103 t3 240702:22:30 240703:00:30 Do the laundry
102 t2 240320:21:00 240320:22:30 Vacuum the living room
101 t1 240511:01:30 240511:03:00 Wash the dishes
      DOC
      stderr: ""
    })
  end

  with_value '-c task,id,text' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
│ task │ id  │ text                   │
├--------------------------------------
│ t6     106   Mow the lawn
│ t5     105   Clean the bathroom
│ t4     104   Take out the trash
│ t3     103   Do the laundry
│ t2     102   Vacuum the living room
│ t1     101   Wash the dishes
      DOC
      stderr: ""
    })
  end

  with_value '-mcid' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
106
105
104
103
102
101
      DOC
      stderr: ""
    })
  end

  with_value '-mcid -f102' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
102
      DOC
      stderr: ""
    })
  end

  with_value '-mcid -ftask=t3' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
103
      DOC
      stderr: ""
    })
  end

  with_value '-mcid -ftext=ras' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
104
      DOC
      stderr: ""
    })
  end
end
