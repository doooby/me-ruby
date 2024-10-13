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

## tasks
me0 [-] (zig) init
me1 [-] (zig) use zig-clap to parse args
me2 [-] (zig) sqlite integration
me3 [x] move to ruby
me4 [ ] opt parsing, task cli command

## dev log
date | task | hours | text
240921 me0 20 learning basics, linking sqlite3
240922 me0 1 vision
date | start | end | task | text
241002 18:45 19:15 me1 revert to zig 0.13
241003 14:00 14:45 i give up
241013 12:00 me3, me4