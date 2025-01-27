# TODO me14
# a task to spin up production server and opens a browser
# bin/production_exec bin/rails s -p
# or just print the URL before startup
#
# checks that the frontend App is present
#
# checks that the DB is present
#
# prints last backup time
#
#-----------------
# script to update production source code
# (backups DB, applies migrations)

class ShellCallException < Exception
end

namespace :production do
  # desc "Update the application code and dependencies"
  # task :update do
  #   # update from github git@github.com:doooby/me-ruby.git
  #   # git
  #   # 1. Update dependencies
  #   Rake::Task["bundle:update"].invoke

  #   # 2. Migrate the database (if necessary)
  #   Rake::Task["db:migrate"].invoke

  #   # 3. Restart the application server (e.g., Puma, Passenger, Unicorn)
  #   # (This step will vary depending on your application server)
  #   # Example for Puma:
  #   # system("sudo systemctl restart puma.service")
  # end

  desc "build production frontend"
  task build: :environment do
    check_is_production!
    Dir.chdir "vendor/frontend" do
      shell_call! "npm install"
      shell_call! "npm run build"
    end
    shell_call! "rails assets:precompile"
  end

  def check_is_production!
    raise "not prod" unless Rails.env.production?
  end

  def shell_call! command
    puts command.blue
    system command
    raise ShellCallException unless $?.exitstatus.zero?
  rescue ShellCallException
    puts "shell call exception".red
    exit 1
  end
end
