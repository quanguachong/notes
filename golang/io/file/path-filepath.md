# some methods in path/filepath

## filepath.Base(path string) string {}

Base returns the last element of path.

Trailing path separators are removed before extracting the last element.

If the path is empty, Base returns ".".

If the path consists entirely of separators, Base returns a single separator.

e.g.

```go
str := "/etc/volumemanagers/pod.tmpl"
str1 := ""
str2 := "//"
fmt.Println(filepath.Base(str))  // output is "pod.tmpl"
fmt.Println(filepath.Base(str1)) // output is "."
fmt.Println(filepath.Base(str2)) // output is "/"
```