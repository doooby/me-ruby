require 'rails_helper'
require 'open3'

RSpec.describe 'CLI: start', type: :cli do
  it '``'.yellow do
    result = cli! "start"
    expect(result[:status].success?).to be(false)
    expect(result[:stdout]).to eq(<<-DOC
#{"missing TASK_NAME".red}

#{"Usage: me start TASK_NAME [TEXT]".blue}
    -h, --help                       Prints this help
    DOC
    )
  end
end
