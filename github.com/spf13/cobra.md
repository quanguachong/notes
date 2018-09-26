# cobra

Catalog:

* [Overview](#Overview)
* [Concepts](#Concepts)
    * [Commands](#Commands)
    * [Flags](#Flags)
* [Getting Started](#Getting-Started)
    * [Using the Cobra Generator](#Using-the-Cobra-Generator)
    * [Using the Cobra Library](#Using-the-Cobra-Library)
    * [Working with Flags](#Working-with-Flags)
        * [Persistent Flags](#Persistent-Flags)
        * [Local Flags](#Local-Flags)
        * [Local Flag on Parent Commands](#Local-Flag-on-Parent-Commands)
        * [Required flags](#Required-flags)
        * [Bind Flags with Config](#Bind-Flags-with-Config)
    * [Positional and Custom Arguments](#Positional-and-Custom-Arguments)
    * [Help Command](#Help-Command)
    * [Usage Message](#Usage-Message)
    * [PreRun and PostRun Hooks](#PreRun-and-PostRun-Hooks)
## Overview

Cobra is both a library for creating powerful modern CLI applications as well as a program to generate applications and command files.

Cobra provides( see [details](https://github.com/spf13/cobra#overview)):

* Easy subcommand-based CLIs: app server, app fetch, etc.
* Fully POSIX-compliant flags (including short & long versions)
* Nested subcommands
* Global, local and cascading flags

## Concepts

Cobra is built on a structure of commands, arguments & flags.

**Commands** represent actions, **Args** are things and **Flags** are modifiers for those actions.

For example: 'server' is a command, and 'port' is a flah

```console
hugo server --port=1313
```

### Commands

Command is the central point of the application. Each interaction that the application supports will be contained in a Command. A command can have children commands and optionally run an action.

```go
// Command is just that, a command for your application.
// E.g.  'go run ...' - 'run' is the command. Cobra requires
// you to define the usage and description as part of your command
// definition to ensure usability.
type Command struct{
    // Use is the one-line usage message.
    Use string

    // Short is the short description shown in the 'help' output.
	Short string

	// Long is the long message shown in the 'help <this-command>' output.
    Long string
    
    // Run: Typically the actual work function. Most commands will only implement this.
    Run func(cmd *Command, args []string)
    
    // contains filtered or unexported fields
}
```


func **AddCommand**

```go
// AddCommand adds one or more commands to this parent command.
func (c *Command) AddCommand(cmds ...*Command) {}
```

-----------------------------------

func **Flags**

```go
// Flags returns the complete FlagSet that applies
// to this command (local and persistent declared here and by all parents).
func (c *Command) Flags() *flag.FlagSet {}
```

-----------------------------------

func **Execute**

```go
// Execute uses the args (os.Args[1:] by default)
// and run through the command tree finding appropriate matches
// for commands and then corresponding flags.
// After ensure the corresponding command, execute it.
func (c *Command) Execute() error{}
```

-----------------------------------


### Flags

A flag is a way to modify the behavior of a command. Cobra supports fully POSIX-compliant flags as well as the Go flag package.

Flag functoinality is provided by the spf13/pflag, a fork of the flag standard library which maintains the same interface while adding POSIX compliance.

## Getting Started

The common organizational structure:

```console
  ▾ appName/
    ▾ cmd/
        add.go
        your.go
        commands.go
        here.go
      main.go
```

In a Cobra app, typically the main.go file is very bare. It serves one purpose: initializing Cobra.

```go
package main

import (

  "{pathToYourApp}/cmd"
)

func main() {
  cmd.Execute()
}
```

### Using the Cobra Generator

Cobra provides its own program that will create your application and add any commands you want. It's the easiest way to incorporate Cobra into your application.

1. First, install it:
```console
go get github.com/spf13/cobra/cobra
```

2. cobra init
```console
cobra init test/newApp
```

The upper command will create a file named newApp, the structure is as following
```console
  ▾ appName/
    ▾ cmd/
        root.go
      main.go
```

3. cobra add
```console
cobra add serve
cobra add config
cobra add create -p 'configCmd'
```

After run the upper commands, the stucture is as following
```console
  ▾ appName/
    ▾ cmd/
        config.go
        create.go
        root.go
        serve.go
      main.go
```

However, the flag  -p 'configCmd' makes the function init() in create.go is
```go
func init() {
	configCmd.AddCommand(createCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// createCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// createCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
```

The application has layers.

* In config.go's init() : rootCmd.AddCommand(configCmd)
* In serve.go's init()  : rootCmd.AddCommand(serveCmd)
* In create.go's init() : configCmd.AddCommand(createCmd)

the layers is 
```console
            main.go
          /         \
      config      serve
         |
      create
```

```bash
go run main.go # the root.go's Command is excuted, the subCommand is not invoked!!!
go run main.go serve  # get result: serve called
go run main.go config # get result: config called
go run main.go config create # get result: create called
```

**Notes**: the "serve" "config" "create" keywords are used according to the string Command.Use

### Using the Cobra Library

To manually implement Cobra you need to create a bare main.go file and a rootCmd file. You will optionally provide additional commands as you see fit. 
[Details in github](https://github.com/spf13/cobra#using-the-cobra-library)

1. Create roorCmd(in app/cmd/root.go)
2. Create your main.go
3. Create additional commands

### Working with Flags

Flags provide modifiers to control how the action command operates.

#### Persistent Flags

A flag can be 'persistent' meaning that this flag will be available to **the command** it's assigned to as well as **every command under that command**.

For global flags, assign a flag as a persistent flag on the root.
```go
rootCmd.PersistentFlags().BoolVarP(&Verbose, "verbose", "v", false, "verbose output")
```

#### Local Flags

A flag can also be assigned locally which will only apply to that specific command.
```go
rootCmd.Flags().StringVarP(&Source, "source", "s", "", "Source directory to read from")
```

#### Local Flag on Parent Commands

By default Cobra only parses local flags on the target command, any local flags on parent commands are ignored. By enabling Command.TraverseChildren Cobra will parse local flags on each command before executing the target command.

```go
command := cobra.Command{
  Use: "print [OPTIONS] [COMMANDS]",
  TraverseChildren: true,
}
```

#### Required flags

Flags are optional by default. If instead you wish your command to report an error when a flag has not been set, mark it as required:

```go
rootCmd.Flags().StringVarP(&Region, "region", "r", "", "AWS region (required)")
rootCmd.MarkFlagRequired("region")
```

#### Bind Flags with Config

You can also bind your flags with spf13/viper, more infos see [viper](./viper.md):

```go
var author string

func init() {
  rootCmd.PersistentFlags().StringVar(&author, "author", "YOUR NAME", "Author name for copyright attribution")
  viper.BindPFlag("author", rootCmd.PersistentFlags().Lookup("author"))
}
```

In this example the persistent flag **author** is bound with viper. Note, that the variable **author** will not be set to the value from config, when the --author flag is not provided by user.

### Positional and Custom Arguments

In struct Command, you can specify validation in Args. There are also some build-in validators in spf13/cobra/args.go

```go
type PositionalArgs func(cmd *Command, args []string) error

----------------------------------------------------------
type Command struct{
  ...
  // Expected arguments
	Args PositionalArgs
  ...
}
```

For example: we add Command.Args in config.go, you can s

```go
var configCmd = &cobra.Command{
	Use:   "config",
	Short: "A brief description of your command",
	Args: func(cmd *cobra.Command, args []string) error{
		if len(args) < 1{
			fmt.Println("no args")
		}else{
			fmt.Println(args[0])
		}
		return nil
	},
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("config called")
	},
}
```

When you run the following command in console
```bash
$ go run main.go config
no args
config called

$ go run main.go config abc
abc
config called
```

You can also set the args using codes:
```go
rootCmd.SetArgs([]string{"config","abc"})
rootCmd.Execute()
```

Then
```bash
$ go run main.go
abc
config called
```

### Help Command

You can provide your own Help command or your own template for the default command to use with following functions:

```go
cmd.SetHelpCommand(cmd *Command)
cmd.SetHelpFunc(f func(*Command, []string))
cmd.SetHelpTemplate(s string)
```

### Usage Message

When the user provides an invalid flag or invalid command, Cobra responds by showing the user the 'usage'.

You can provide your own usage function or template for Cobra to use. Like help, the function and template are overridable through public methods:

```go
cmd.SetUsageFunc(f func(*Command) error)
cmd.SetUsageTemplate(s string)
```

### PreRun and PostRun Hooks

It is possible to run functions before or after the main Run function of your command.

* The **PersistentPreRun** and **PreRun** functions will be executed before Run.
* **PersistentPostRun** and **PostRun** will be executed after Run.

Notes: The Persistent*Run functions will be inherited by children if they do not declare their own. These functions are run in the following order:

1. PersistentPreRun
2. PreRun
3. Run
4. PostRun
5. PresistentPostRun

Example:
```go
package main

import (
  "fmt"

  "github.com/spf13/cobra"
)

func main() {

  var rootCmd = &cobra.Command{
    Use:   "root [sub]",
    Short: "My root command",
    PersistentPreRun: func(cmd *cobra.Command, args []string) {
      fmt.Printf("Inside rootCmd PersistentPreRun with args: %v\n", args)
    },
    PreRun: func(cmd *cobra.Command, args []string) {
      fmt.Printf("Inside rootCmd PreRun with args: %v\n", args)
    },
    Run: func(cmd *cobra.Command, args []string) {
      fmt.Printf("Inside rootCmd Run with args: %v\n", args)
    },
    PostRun: func(cmd *cobra.Command, args []string) {
      fmt.Printf("Inside rootCmd PostRun with args: %v\n", args)
    },
    PersistentPostRun: func(cmd *cobra.Command, args []string) {
      fmt.Printf("Inside rootCmd PersistentPostRun with args: %v\n", args)
    },
  }

  var subCmd = &cobra.Command{
    Use:   "sub [no options!]",
    Short: "My subcommand",
    PreRun: func(cmd *cobra.Command, args []string) {
      fmt.Printf("Inside subCmd PreRun with args: %v\n", args)
    },
    Run: func(cmd *cobra.Command, args []string) {
      fmt.Printf("Inside subCmd Run with args: %v\n", args)
    },
    PostRun: func(cmd *cobra.Command, args []string) {
      fmt.Printf("Inside subCmd PostRun with args: %v\n", args)
    },
    PersistentPostRun: func(cmd *cobra.Command, args []string) {
      fmt.Printf("Inside subCmd PersistentPostRun with args: %v\n", args)
    },
  }

  rootCmd.AddCommand(subCmd)

  rootCmd.SetArgs([]string{""})
  rootCmd.Execute()
  fmt.Println()
  rootCmd.SetArgs([]string{"sub", "arg1", "arg2"})
  rootCmd.Execute()
}
```

```bash
$ go run main.go
Inside rootCmd PersistentPreRun with args: []
Inside rootCmd PreRun with args: []
Inside rootCmd Run with args: []
Inside rootCmd PostRun with args: []
Inside rootCmd PersistentPostRun with args: []

Inside rootCmd PersistentPreRun with args: [arg1 arg2]
Inside subCmd PreRun with args: [arg1 arg2]
Inside subCmd Run with args: [arg1 arg2]
Inside subCmd PostRun with args: [arg1 arg2]
Inside subCmd PersistentPostRun with args: [arg1 arg2]
```