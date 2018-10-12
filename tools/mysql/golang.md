# Usual syntax in golang

`import "database/sql"`

### QueryRow to judge if rows existed

```go
// QueryRow only get one row which matches the query condition
// If rows is not existed, err is `sql.ErrNoRows`
var version_id int
err := s.db.QueryRow("SELECT version_id FROM versions WHERE version_id=?", id).Scan(&version_id)
```

