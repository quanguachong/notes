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

The struct's fields must be exported to use json.Marshal

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