# pflag

## Overview

pflag is a drop-in replacement for Go's flag package, implementing POSIX/GNU-style --flags.

## Constructure in codes

1. type FlagSet

    ```go
    // A FlagSet represents a set of defined flags. 
    type FlagSet struct {
        // Usage is the function called when an error occurs while parsing flags.
        // The field is a function (not a method) that may be changed to point to
        // a custom error handler.
        Usage func()

        // SortFlags is used to indicate, if user wants to have sorted flags in
        // help/usage messages.
        SortFlags bool

        // ParseErrorsWhitelist is used to configure a whitelist of errors
        ParseErrorsWhitelist ParseErrorsWhitelist
        // contains filtered or unexported fields
    }
    ```

2. pflag.CommandLine

    ```go
    // CommandLine is the default set of command-line flags, parsed from os.Args.
    // The top-level functions such as BoolVar, Arg, and so on are wrappers for the
    // methods of CommandLine.
    var CommandLine = NewFlagSet(os.Args[0], ExitOnError)
    ```

## Usage

```go
  var flag1 *int = pflag.Int("flagname1",1,"help message for flag1")
  var flag2 int
  pflag.IntVar(&flag2,"flagname2",2,"help message for flag2")
  var flag3 *int = pflag.IntP("flagname3","f",3,"help message for flag3")
  var flag4 int
  pflag.IntVarP(&flag4,"flagname4","F",4,"help message for flag4")
  pflag.Parse()

  fmt.Println(*flag1)
  fmt.Println(flag2)
  fmt.Println(*flag3)
  fmt.Println(flag4)
  fmt.Println(pflag.CommandLine.GetInt("flagname3"))
```

```bash
$ go run temp.go --flagname1 11 -f 33
11
2
33
4
33 <nil>
```

## Supporting Go flags when using pflag

In order to support flags defined using Go's **flag** package, they must be added to the **pflag** flagset. This is usually necessary to support flags defined by third-party dependencies (e.g. golang/glog).

Example: You want to add the Go flags to the **CommandLine** flagset

```go
var ip *int = flag.Int("flagname", 1234, "help message for flagname")

func main() {
  pflag.CommandLine.AddGoFlagSet(flag.CommandLine)
  pflag.Parse()
  fmt.Println(*ip)
}
```

```bash
$ go run temp.go --flagname 12
12
```