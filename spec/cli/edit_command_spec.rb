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
      exit: "status: 1",
      stdout: <<-DOC,
#{"missing TASK_ID".red}
      DOC
      stderr: ""
    })
  end

  #   with_value '101 -atask=ticket123' do |value|
  #     result = invoke! value
  #     expect(result).to eq({
  #       exit: "status: 0",
  #       stdout: <<-DOC,
  # #{"what is happening".red}
  # // it needs to confirm the edit in default mode
  #       DOC
  #       stderr: ""
  #     })
  #   end
end
