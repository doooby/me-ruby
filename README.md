# ME
a tool to track my hours for dev tasks

## CLI arguments
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


