# ME
a tool to track my hours for dev tasks

## USE
Currenty, I just git clone this to `/me/src` and use it "globaly" from there.

Cli:
```bash
mes -t123 -m"i have a goal"
me ls --per 1
mee 42 -as=:1000 -ae=:
```
for details skip [here](#cli-commands).

There is also a web:
```bash
(cd /me/src && bin/production_exec bin/rails s)
```

### current production setupj
#### install:
read and execute [https://raw.githubusercontent.com/doooby/me-ruby/refs/heads/main/lib/installation/create_me_directory.sh](this) script to setup "/me" directory structure. Find appropriate version, if you don't want main branch.
```bash
cd /me/src
bin/production_exec bin/rails db:create db:schema:load
bin/production_exec bin/rails db:migrate
bin/production_exec bin/rails production:build

# setup shell aliases
# - me='/me/bin/mecli'
# - mes='/me/bin/mecli_start'
# - mee='/me/bin/mecli edit'
# - mei='/me/bin/mecli interactive'
# - mew='(cd /me/src && bin/production_exec bin/rails s)'

# copy rails master key
```

#### update code
```bash
cd /me/src
git pull
bundle install
bin/production_exec bash lib/installation/create_database.sh
bin/production_exec bin/rails production:build
```

#### DB manipulations
```bash
# backup
bck_date="250122"
cp /me/var/production.sqlite3 /me/var/production.sqlite3.$bck_date.bck
# restore
cp /tmp/me-db-path /me/var/production.sqlite3
```

## Cli Commands {#cli-commands}
```bash
# TODO
```


## TODO docs
```bash
# TODO rename Me::CliCommands::* => Me::Command::*, Me::CommandBase => Me::Command
# TODO copy rails master key
# TODO add database (either from backup or create new one)
# TODO install bash command alias for /me/src/bin/cli.rb

cd /me/src
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/production_exec bin/rails db:reset
bin/production_exec bin/rails db:create db:schema:load
bin/production_exec bin/rails db:migrate

me ls
me ls -v
me lsv -fid=$task_id

mes me13 revision
me start -atask=me13 -amessage=revision -astart=250101:1200
me task -tme13 -mrevision -astart=:1200

mee 13 # TODO v1.0 message: pass new attributes
me edit 13 -mrevision -astart=:1200
me edit 13 -tme13 -e_:2000 # TODO v1.0
me edit 13 -e:-0010 # TODO v1.0
me edit 13 -e_:+10 # TODO v1.0

# ------------------

me start
me t
me t -at=t123 -am="ahoj karel"
me t -at=me7 -as=:1230 -am"delam na tom" -ae=:

me stop # put end_date to last task, notify if older then a day.
me p [task] # always prompt to verify

me list # always sort by updated_at
me ls
me list -i # print only ID
me list -u # filter unfinished
me list -c10 # lists 10 records (default)

me edit <ID> # print it and prompt to verify
me edit <task> # print (list) if ambiguous and let user select.
  --> in next step: ([attribute="value with space"], ...)
me e 123 -ae=:
```


