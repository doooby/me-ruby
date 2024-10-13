#!/usr/bin/env ruby

Dir.chdir File.expand_path("..", __dir__) do
  require "#{Dir.pwd}/config/environment"
  Me::Cli.run! ARGV
end
