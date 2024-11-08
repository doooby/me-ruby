require 'rails_helper'
require 'open3'

RSpec.describe 'CLI:', type: :cli do
  HELP_MESSAGE = <<-DOC
#{"Usage: me COMMAND [ARGS]".blue}

-- COMMANDS
start, t   adds new task record
list, ls   list records
edit, e    edit a record
  DOC

  with_value '' do |value|
    result = run_cli! value
    expect(result[:stdout]).to eq(<<-DOC
#{"bad command".red}

#{HELP_MESSAGE.strip}
    DOC
    )
    expect(result[:status].success?).to be(false)
  end

  with_value '-h' do |value|
    result = run_cli! value
    expect(result[:stdout]).to eq(HELP_MESSAGE)
    expect(result[:status].success?).to be(true)
  end
end
