# notes for shell

## Variables

Variables are created once they are assigned a value.

* case sensitive

* no space permitted on either side of =

* a backslash "\" is used to escape special character meaning

* ${variable} encapsulate the variable name with ${} to avoid ambiguity

* Encapsulating the variable name with "" will preserve any white space values, otherwise multiple one white space value

* variables can be assigned with the value of a command output,the command is encapsulated with `` or $(). When the script runs, it will run the command inside the $() parenthesis and capture its output.

## Passing Arguments to the Script

```bash
#!/bin/bash

echo $0
echo $1
echo $2
echo $3
echo $#
echo $@
```

```console
$ ./test.sh apple 1 "ok ok"
./test.sh
apple
1
ok ok
3
apple 1 ok ok
```
In test.sh, $0 means `./test.sh`, $1 means `apple`, $2 means `1`, $3 means `ok ok`

$# means 3, the number of arguments

$@ means a space delimited string of all arguments passed to the script

## grammer

command1;command2   不管command1是否执行成功都会执行command2；

command1 && command2 只有command1执行成功后，command2才会执行，否则command2不执行；

command1 || command2 command1执行成功后command2 不执行，否则去执行command2.