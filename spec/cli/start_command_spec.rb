require 'rails_helper'

RSpec.describe 'CLI: start', type: :cli do
  after :each do
    Me::Cli.set_now nil
  end

  def invoke! value
    fake_cli! Me::CliCommands::Start, value
  end

  with_value '' do |value|
    result = invoke! value
    expect(result).to eq({
      exit: "status: 1",
      stdout: <<-DOC,
#{"missing TASK_NAME".red}
      DOC
      stderr: ""
    })
  end

  with_value 'me5' do |value|
    Me::Cli.set_now Time.new(2024, 10, 14, 10, 05)
    result = invoke! value
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

  with_value 'me5 -t"first task"' do |value|
    Me::Cli.set_now Time.new(2024, 10, 14, 10, 05)
    result = invoke! value
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
end
