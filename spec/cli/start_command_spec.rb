require 'rails_helper'
require 'open3'

RSpec.describe 'CLI: start', type: :cli do
  after :each do
    Me::Cli.set_now nil
  end

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

  it '`t me5`'.yellow do
    Me::Cli.set_now Time.new(2024, 10, 14, 10, 05)
    result = fake_cli! Me::CliCommands::Start, 'me5'
    record = Task.last
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
#{"#{record&.id} me5 241014:10:05".green}
      DOC
      stderr: ""
    })
    expect(record.created_at).to be_present
    expect(record.task).to eq("me5")
    expect(record.text).to be_nil
    expect(Me::Terminal.format_time record.start_at).to eq("241014:10:05")
    expect(record.end_at).to be_nil
  end

  it '`t me5 -t"first task"`'.yellow do
    Me::Cli.set_now Time.new(2024, 10, 14, 10, 05)
    result = fake_cli! Me::CliCommands::Start, 'me5 -t"first task"'
    record = Task.last
    expect(result).to eq({
      exit: "status: 0",
      stdout: <<-DOC,
#{"#{record&.id} me5 241014:10:05 first task".green}
      DOC
      stderr: ""
    })
    expect(record.created_at).to be_present
    expect(record.task).to eq("me5")
    expect(record.text).to eq("first task")
    expect(Me::Terminal.format_time record.start_at).to eq("241014:10:05")
    expect(record.end_at).to be_nil
  end

  #   it '`t me5 -t"first task"`'.yellow do
  #     result = fake_cli! Me::CliCommands::Start, 'me5 -t"first task"'
  #     expect(result).to eq({
  #       exit: "status: 0",
  #       stdout: <<-DOC,
  # #{"DONE".green}
  #       DOC
  #       stderr: ""
  #     })
  #     expect_these_tasks [
  #       ->(record) {
  #         expect(record.created_at).to be_present
  #         expect(record.task).to eq("me5")
  #         expect(record.text).to eq("first task")
  #       }
  #     ]
  #   end

  #   t '`t me5 -t"first task"`'.yellow do
  #     result = fake_cli! Me::CliCommands::Start, 'me5 -t"first task"'
  #     expect(result).to eq({
  #       exit: "status: 0",
  #       stdout: <<-DOC,
  # #{"DONE".green}
  #       DOC
  #       stderr: ""
  #     })
  #     expect_these_tasks [
  #       ->(record) {
  #         expect(record.created_at).to be_present
  #         expect(record.task).to eq("me5")
  #         expect(record.text).to eq("first task")
  #       }
  #     ]
  #   end
end
