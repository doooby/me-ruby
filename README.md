# ME
a tool to track my hours for dev tasks

see USE section to see current dev

## Docs 0.9
TODO v0.9
backup DB:
```bash
bck_date="250122"
cp /me/var/production.sqlite3 /me/var/production.sqlite3.$bck_date.bck
```

check & update code
```bash
cd /me/src
git status
# should be on: dev/main
git fetch dev
git merge dev/main
git@github.com:doooby/me-ruby.git
```

build frontend
```bash
bin/production_exec (cd vendor/frontend && npm run build)
bin/production bin/rails assets:precompile
```

## USE
### TODO v1.0 docs
```bash
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

```

## CLI arguments ( v0.9 deprecated )
#### TODO v1.0 cleanup
```
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


