# some tricks

## io.reader from string

```go
// r fits io.reader
r := strings.NewReader("This is a io.reader stream")
```

## pachyderm put-file

```go
// Create file a0.asset for repo:"modelreg_test_user" branch:"master"
	commit, err := s.storage.pachApi.StartCommit(testPachRepo, pachBranch)
	if err != nil {
		return nil, err
	}

    r := strings.NewReader("This is an asset [a0].\n")
    // "a0.asset" means the filename or path to file
	_, err = s.storage.pachApi.PutFile(testPachRepo, commit.ID, "a0.asset", r)
	if err != nil {
		return nil, err
	}
	err = s.storage.pachApi.FinishCommit(testPachRepo, commit.ID)
	if err != nil {
		return nil, err
	}
```

## for loop

The loop in the following code, use the temp variable `ctrl` to avoid override

```go
// Start the runnables after the cache has synced
	for _, c := range cm.runnables {
		// Controllers block, but we want to return an error if any have an error starting.
		// Write any Start errors to a channel so we can return them
		ctrl := c
		go func() {
			cm.errChan <- ctrl.Start(stop)
		}()
	}
```

## json.Marshal

The struct's fields must be exported when using json.Marshal

```go
...
type message struct{
	// The first letter must be capital
	Time string
	Num int
}

newMessage := message{
	Time: "2018.11.6"
	Num: 12
}

msg,err := json.Marshal(newMessage)
...
```

```go
type person struct{
	...
}
person1 := person{...}
// data's type is []byte
// But, it is easy to read for human
data, err := json.MarshalIndent(person1, "", "  ")
```

## common file operator

```go
// import ("path/filepath")
// Get the absolute representation,p's type is string
p, err := filepath.Abs(filePath)

// Get the fileInfo of p(a filePath),f's type is the interface FileInfo
f, err := os.Stat(p)

// Get a rooted path name corresponding to the current directory
wd,err := os.Getwd()

// ioutil.TempDir creates a new directory in the directory dir with
// a name beginning with prefix(the rest part is a random string auto-generated) 
// and return the path of the new directory
tmp, err := ioutil.TempDir(dir,prefix)

// filepath.Join(elem ...string) joins any number of path elements into a single path
// `os.Create(name string) (*File, error)` create file according to the name
// if successful,method of returned File can be used for I/O
file, err := os.Create(filepath.Join(tmp, "stdout"))

// data's type is []byte, 0644 means permissions
// WriteFile writes data to a file, if the file does not exist
// it will create the file with the permissions 0644
err = ioutil.WriteFile(filepath.Join(tmp, "proc"), data, 0644)
```

## exec in golang

```go
// import("os/exec")
// CommandContext is like a command but includes a context(used to kill the process)
// command's type is Cmd
cmd := exec.CommandContext(ctx,name,args...)

// Set parts of Cmd
cmd.Dir = workingDir
cmd.Env = env
cmd.Stdout = stdoutFile
cmd.Stderr = stderrFile

// start the command
cmd.Start()
```