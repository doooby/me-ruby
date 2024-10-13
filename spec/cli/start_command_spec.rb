require 'rails_helper'
require 'open3'

RSpec.describe 'CLI: start', type: :cli do
  it '``'.yellow do
    result = fake_cli! Me::CliCommands::Start, ""
    expect(result).to eq({
      exit: "status: 1",
      stdout: <<-DOC,
#{"missing TASK_NAME".red}
      DOC
      stderr: ""
    })
  end

  it '`t me5 "first task"`'.yellow do
    result = fake_cli! Me::CliCommands::Start, 'me5 "first task"'
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
#{"DONE".green}
      DOC
      stderr: ""
    })
    expect_these_tasks [
      ->(record) {
        expect(record.created_at).to be_present
        expect(record.task).to eq("me5")
        expect(record.text).to eq("first task")
      }
    ]
  end
end
