# GOROOT‘s text/template
see GOROOT/text/template/doc.go for introductions

usage e.g.

```go
//Here is a trivial example that prints "17 items are made of wool".
type Inventory struct {
   Material string
   Count    uint
}
sweaters := Inventory{"wool", 17}
tmpl, err := template.New("test").Parse("{{.Count}} items are made of {{.Material}}")
if err != nil { panic(err) }
err = tmpl.Execute(os.Stdout, sweaters)
if err != nil { panic(err) }
```