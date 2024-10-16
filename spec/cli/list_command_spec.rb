require 'rails_helper'
require 'open3'

RSpec.describe 'CLI: list', type: :cli do
  fixtures :tasks

  it '``'.yellow do
    result = fake_cli! Me::CliCommands::List, ''
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
│ index │ id  │ task │ start        │ end          │ text                   │
├----------------------------------------------------------------------------
│ -1      106   t6     240813:02:00   240813:04:00   Mow the lawn
│ -2      105   t5     240601:21:00   240601:22:00   Clean the bathroom
│ -3      104   t4     240416:05:00   240416:05:30   Take out the trash
│ -4      103   t3     240702:22:30   240703:00:30   Do the laundry
│ -5      102   t2     240320:21:00   240320:22:30   Vacuum the living room
│ -6      101   t1     240511:01:30   240511:03:00   Wash the dishes
      DOC
      stderr: ""
    })
  end

  it '`-m`'.yellow do
    result = fake_cli! Me::CliCommands::List, '-m'
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
-1 106 t6 240813:02:00 240813:04:00 Mow the lawn
-2 105 t5 240601:21:00 240601:22:00 Clean the bathroom
-3 104 t4 240416:05:00 240416:05:30 Take out the trash
-4 103 t3 240702:22:30 240703:00:30 Do the laundry
-5 102 t2 240320:21:00 240320:22:30 Vacuum the living room
-6 101 t1 240511:01:30 240511:03:00 Wash the dishes
      DOC
      stderr: ""
    })
  end

  it '`-c task,id,text`'.yellow do
    result = fake_cli! Me::CliCommands::List, '-c task,id,text'
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

  it '`-mcid`'.yellow do
    result = fake_cli! Me::CliCommands::List, '-mcid'
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
end
