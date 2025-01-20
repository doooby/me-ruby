# TODO me18
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

namespace :production do
  desc "Update the application code and dependencies"
  task :update do
    # update from github git@github.com:doooby/me-ruby.git
    # git
    # 1. Update dependencies
    Rake::Task["bundle:update"].invoke

    # 2. Migrate the database (if necessary)
    Rake::Task["db:migrate"].invoke

    # 3. Restart the application server (e.g., Puma, Passenger, Unicorn)
    # (This step will vary depending on your application server)
    # Example for Puma:
    # system("sudo systemctl restart puma.service")
  end
end
