require 'rails_helper'
require 'open3'

RSpec.describe 'CLI:', type: :cli do
  HELP_MESSAGE = <<-DOC
#{"Usage: me COMMAND [ARGS]".blue}

-- COMMANDS
start, t   adds new task record
list, ls   list records
  DOC

  it '``'.yellow do
    result = cli! ""
    expect(result[:stdout]).to eq(<<-DOC
#{"bad command".red}

#{HELP_MESSAGE.strip}
    DOC
    )
    expect(result[:status].success?).to be(false)
  end

  it '`-h`'.yellow do
    result = cli! "-h"
    expect(result[:stdout]).to eq(HELP_MESSAGE)
    expect(result[:status].success?).to be(true)
  end
end
