class Me::CliCommands::Interactive < Me::CommandBase
  def run
    require "irb"
    binding.irb
  end
end
