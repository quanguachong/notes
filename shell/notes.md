# notes for shell

## variables

* case sensitive

* no space permitted on either side of =

* a backslash "\" is used to escape special character meaning

* ${variable} encapsulate the variable name with ${} to avoid ambiguity

* variables can be assigned with the value of a command output,the command is encapsulated with `` or $(). When the script runs, it will run the command inside the $() parenthesis and capture its output.

Tips:

```sh
date -d "$date1" +%A #output the day of the week of date1
```

## Passing Arguments to the Script

./test.sh apple 1