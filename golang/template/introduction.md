# package template

**catalog**
* [method](#method)
* [usage example](#usage_example)

------------------------------------

Package template implements data-driven templates for generating textual output.

trivial example:

```go
// this example will prints "17 items are made of wool"
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

## method

Template is the representation of a parsed template.

```go
type Template struct{
    *parse.Tree
    // contains filtered or unexported fields
}
```
-----------------------------

func **New**
```go
func New(name string) *Template
```

New allocates a new, undefined template with the given name.

-----------------------------

func **Funcs**
```go
type FuncMap map[string]interface{}

func (t *Template) Funcs(funcMap FuncMap) *Template
```

Funcs adds the elements of the argument map to the template's function map.

It must be called before the template is parsed.

It panics if a value in the map is not a function with appropriate return type or if the name cannot be used syntactically as a function in a template.

**What this really means ?**

You can define custom function for the template using Funcs.

The argument funcMap of Funcs is a map whose:
* key is the name of method
* value is the method

To invoke the method, use {{funcname .arg1 .arg2}} in .tmpl file.

e.g.:

The custom func is
```go
func add(left, right int) int{
    return left + right
}
```
You can get 3 by use {{add 1 2}} in .tmpl file.

--------------------------

func **Parse**
```go
func (t *Template) Parse(text string) (*Template, error)
```

Parse parses text as a template body for t.

--------------------------

func **ParseFiles**
```go
func (t *Template) ParseFiles(filenames ...string) (*Template, error)
```

ParseFiles parses the named files and associates the resulting templates with t.

If an error occurs, parsing stops and the returned template is nil; otherwise it is t.

----------------------------

func **Execute**
```go
func (t *Template) Execute(wr io.Writer, data interface{}) error
```

Execute applies a parsed template to the specified data object, and writes the output to wr.

Attachment：
```go
// Writer is the interface that wraps the basic Write method.
//
// Write writes len(p) bytes from p to the underlying data stream.
// It returns the number of bytes written from p (0 <= n <= len(p))
// and any error encountered that caused the write to stop early.
// Write must return a non-nil error if it returns n < len(p).
// Write must not modify the slice data, even temporarily.
//
// Implementations must not retain p.
type Writer interface {
	Write(p []byte) (n int, err error)
}
```

## usage_example

The following codes use funcs:

New, Funcs, ParseFiles, Execute

```go
// Reify returns the resulting JSON by expanding the template using the
// supplied data.
func (r *Reify) Reify(templateFileName string, templateValues interface{}) (json []byte, err error) {
	// Due to a weird quirk of go templates, we must pass the base name of the
	// template file to template.New otherwise execute can fail!
	baseFileName := filepath.Base(templateFileName)
	tmpl := template.New(baseFileName).Funcs(template.FuncMap{
		"ResourceString": func(r resource.Quantity) string {
			return (&r).String()
		},
	})
	tmpl, err = tmpl.ParseFiles(templateFileName)
	if err != nil {
		glog.Warningf("[reify] error parsing template file: %v", err)
		return nil, err
	}

	var buf bytes.Buffer
	err = tmpl.Execute(&buf, templateValues)
	if err != nil {
		return nil, err
	}

	// Translate YAML to JSON.
	json, err = yaml.YAMLToJSON(buf.Bytes())

	glog.Infof("reified template [%s] with data [%v]:\nYAML:\n%s\n\nJSON:\n%s", templateFileName, templateValues, buf.String(), string(json))

	return
}
```
