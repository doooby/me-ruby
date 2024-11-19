require 'rails_helper'

RSpec.describe 'CLI: start', type: :cli do
  after :each do
    Me::Cli.set_now nil
  end

  let(:point_in_time){ Time.new 2002, 2, 2, 2, 2 }

  def invoke! value
    fake_cli! Me::CliCommands::Start, value
  end

  with_value '' do |value|
    Me::Cli.set_now point_in_time
    result = invoke! value
    expect(result).to eq({
      stdout: <<-DOC
│ id  │ task │ start        │ end │ text │
├----------------------------------------┤
│ 107          020202:02:02              |
└----------------------------------------┘
      DOC
    })
  end

    with_value '-tme5 -m"this is text"' do |value|
      Me::Cli.set_now point_in_time
      result = invoke! value
      record = Task.last
      expect(result).to eq({
        stdout: <<-DOC
│ id  │ task │ start        │ end │ text         │
├------------------------------------------------┤
│ 107   me5    020202:02:02         this is text |
└------------------------------------------------┘
        DOC
      })
      expect(record.created_at).to be_present
      expect(record.task).to eq('me5')
      expect(record.text).to eq('this is text')
      expect(record.start_at).to eq(point_in_time)
      expect(record.end_at).to be_nil
    end

    with_value '-ae=:2000' do |value|
      Me::Cli.set_now point_in_time
      result = invoke! value
      record = Task.last
      expect(result).to eq({
        stdout: <<-DOC
│ id  │ task │ start        │ end          │ text │
├-------------------------------------------------┤
│ 107          020202:02:02   020202:20:00        |
└-------------------------------------------------┘
        DOC
      })
      expect(record.created_at).to be_present
      expect(record.start_at).to eq(point_in_time)
      expect(record.end_at).to eq(point_in_time.change hour: 20)
    end
end
