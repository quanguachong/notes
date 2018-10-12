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