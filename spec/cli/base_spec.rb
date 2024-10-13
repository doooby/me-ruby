require 'rails_helper'
require 'open3'

RSpec.describe 'CLI:', type: :cli do
  it '``'.yellow do
    result = cli! ""
    expect(result[:status].success?).to be(false)
    expect(result[:stdout]).to eq(<<-DOC
#{"bad command".red}

#{"Usage: me COMMAND [ARGS]".blue}

-- COMMANDS
start, t    adds new task record
    DOC
    )
  end

  it '`-h`'.yellow do
    result = cli! "-h"
    expect(result[:status].success?).to be(true)
    expect(result[:stdout]).to eq(<<-DOC
#{"Usage: me COMMAND [ARGS]".blue}

-- COMMANDS
start, t    adds new task record
    DOC
    )
  end
end
