# ME
a tool to track my hours for dev tasks

## CLI arguments
```
me start # continue previous (should also warn about previous unfinished)
me t t123 "delam na tom" "m,k"
me t <task> [text] [label1 label2 ...]

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
```
