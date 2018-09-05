# Grammar

Catalog:
* [File example](#File-example)
* [Format spaces](#Format-spaces)
* [Arguments and Variables](#Arguments-and-Variables)
* [if else](#if-else)
* [range](#range)
* [with](#with)
* [template and block](#template-and-block)  (TODO)

## File example

.tmpl file is as below

```go
const letter = `
Dear {{.Name}},
{{if .Attended}}
It was a pleasure to see you at the wedding.
{{- else}}
It is a shame you couldn't make it to the wedding.
{{- end}}
{{with .Gift -}}
Thank you for the lovely {{.}}.
{{end}}
Best wishes,
Josie
`
```

## Format spaces

{{- text}} means all white space is trimmed preceding the "text"

{{text -}} means all white space is trimmed after the "text"

for example

```bash 
{{13 -}} < {{- 45}} 
```

output: 
```bash
13<45
```

## Arguments and Variables

Template use **Execute** to set the corresponding arguments in the parsed template with the values in data. Then, writes output to wr.

```go
func (t *Template) Execute(wr io.Writer, data interface{}) error
```

An argument is a simple value, denoted by one of the following. Normally, it likes golang's untyped constants

1. `{{.}}`

    It can be set by any data.

    Example:
    ```go
    const letter = "hello {{.}} {{.}}"
    tmpl,_ := template.New("test").Parse(letter)
    tmpl.Execute(os.Stdout, "abc")
    ```

    ```bash
    $ go run main.go
    hello abc abc
    ```

2. `{{.Field}}` for data(struct)

    It is set according to a field(whose name must be "Field") of the data, the data must be a struct.

    **Notes: The first letter of the argument must be capital**

    Example:
    ```go
    type person struct{
        Age int
    }
    data := person{22}
    //same with: tmpl,err := template.New("test").Parse(`hello {{.Age}} "{{.Age}}" {{.}}`)
    tmpl,err := template.New("test").Parse("hello {{.Age}} \"{{.Age}}\" {{.}}")
    if err != nil { panic(err) }
    err = tmpl.Execute(os.Stdout, data)
    if err != nil { panic(err) }
    ```

    ```bash
    $ go run test.go
    hello 22 "22" {22}
    ```

3. `{{.Field1.Field2}}` for data(struct)

    "Field1" is a field of the data. "Field2" is a field of Field1(Field1 is a stuct, too)

    **Notes: The first letter of "Field2" must be capital, too**

    Example:
    ```go
    type school struct{
    	Name string
    }

    type person struct{
    	Age int
    	Education school
    }

    func main() {
    	data := person{22,school{"pku"}}
    	tmpl,err := template.New("test").Parse("hello {{.Age}} {{.Education.Name}}")
    	if err != nil { panic(err) }
    	err = tmpl.Execute(os.Stdout, data)
    	if err != nil { panic(err) }
    }
    ```

    ```bash
    $ go run test.go
    hello 22 pku
    ```

4. `{{.Key}}` for data(map)

    It is the map element value indexed by the key.

    **Notes: The key does not need to start with upper case letter.**

    Example:
    ```go
    data := make(map[string]string)
    data["name"] = "daming"
    tmpl,err := template.New("test").Parse("hello {{.name}}")
    if err != nil { panic(err) }
    err = tmpl.Execute(os.Stdout, data)
    if err != nil { panic(err) }
    ```

    ```bash
    $ go run test.go
    hello daming
    ```

5. `{{$variable}}` variable for template
    
    ```go
    type person struct{
	    Age int
    }

    func main() {
    	data := person{Age:123}
    	tmpl,err := template.New("test").Parse("hello,{{$val:= .Age}} {{$val}}")
    	if err != nil { panic(err) }
    	err = tmpl.Execute(os.Stdout, data)
	    if err != nil { panic(err) }
    }
    ```

    ```bash
    $ go run test.go
    hello, 123
    ```

6. `{{.Method}}` for method of data

    The result is the value of invoking the Method() in the struct data.

    Such a method must have one return value (of any type) or two return values, the second of which is an error.

    If it has two and the returned error is non-nil, execution terminates and an error is returned to the caller as the value of Execute.

    **Notes: The first letter of the Method must be upper case letter** 

    Example:
    ```go
    type person struct{
    	Age int
    }
    func (p person) GetString(a string) string{
    	return "get string: "+ a
    }

    func main() {
        data := person{Age:12}
    	tmpl,err := template.New("test").Parse("hello, {{.GetString `value`}}")
    	if err != nil { panic(err) }
    	err = tmpl.Execute(os.Stdout, data)
    	if err != nil { panic(err) }
    }
    ```

    ```bash
    $ go run test.go
    hello, get string: value
    ```

7. function

    **Origin func** for example: printf

    Example:
    ```go
    tmpl, err := template.New("test").Parse(`Output : {{printf "%q" .}}`)
    if err != nil{panic(err)}
    err = tmpl.Execute(os.Stdout, "hello world")
    if err != nil {panic(err)}
    ```

    ```bash
    $ go run test.go
    Output : "hello world"
    ```

    **Custom func** defined by template.Funcs()

    Example:
    ```go
    tmpl := template.New("test").Funcs(template.FuncMap{
    		"add": func(a,b int) int{
    			return a+b
    		},
    	})
    tmpl,err := tmpl.Parse("hello, {{add 1 2}}")
    if err != nil { panic(err) }
    err = tmpl.Execute(os.Stdout, nil)
    if err != nil { panic(err) }
    ```

    ```bash
    $ go run test.go
    hello, 3
    ```

## if else

1. `{{if pipeline}} T1 {{end}}`

    A pipeline is a expression which is a argument or a function or method call,

    If the value of pipeline is empty, no output. Otherwise, T1 is executed.
    
    **The empty values are false, 0, any nil pointer or interface value, and any array, slice, map, or string of length zero.**

    dot is unaffected. (Execution of the template walks the structure and sets the cursor, represented by a period '.' and called "dot", to the value at the current location in the structure as execution proceeds. Notes: as my comprehension, it may be the dot of ".Field")

2. `{{if pipeline}} T1 {{else}} T0 {{end}}`

    If the value of the pipeline is empty, T0 is executed; otherwise, T1 is executed.


Example:
```go
type person struct{
    Age int
}

func main() {
    // gt is predefined func, return the boolean truth of arg1 > arg2
	const text = `{{if gt .Age 0}}Hello, Age is positive number{{else}}Age is minus{{end}}`
	data := person{Age:-2}
	tmpl,err := template.New("test").Parse(text)
	if err != nil { panic(err) }
	err = tmpl.Execute(os.Stdout, data)
	if err != nil { panic(err) }
}
```

```bash
$ go run text.go
Age is minus
```

## range

1. `{{range pipeline}} T1 {{end}}`

    The value of the pipeline must be an array, slice, map, or channel.

    If the value of the pipeline has length zero, nothing is output; otherwise, dot is set to the successive elements of the array, slice, or map and T1 is executed.

    Notes:If the value is a map and the keys are of basic type with a defined order ("comparable"), the elements will be visited in sorted key order.

2. `{{range pipeline}} T1 {{else}} T0 {{end}}`

    If the value of the pipeline has length zero, dot is unaffected and T0 is executed; otherwise, dot is set to the successive elements of the array, slice, or map and T1 is executed.

Example:
```go
type person struct{
	Age int
	Labels map[string]string
}

func main() {
	const text = `{{range $key,$val := .Labels}}key is:{{$key}}, value is:{{$val}}. {{end}} `
	data := person{
		Age: 22,
		Labels: map[string]string{
			"sport": "tennis",
			"food":"rice",
		},
	}
	tmpl,err := template.New("test").Parse(text)
	if err != nil { panic(err) }
	err = tmpl.Execute(os.Stdout, data)
	if err != nil { panic(err) }
}
```

```bash
$ go run test.go
key is:food, value is:rice. key is:sport, value is:tennis.  
```

## with

1. `{{with pipeline}} T1 {{end}}`

    If the value of the pipeline is empty, no output is generated; otherwise, dot is set to the value of the pipeline and T1 is executed.

2. `{{with pipeline}} T1 {{else}} T0 {{end}}`

    If the value of the pipeline is empty, dot is unaffected and T0 is executed; otherwise, dot is set to the value of the pipeline and T1 is executed.

```go
type person struct{
	Age int
}

func main() {
	const text = `{{with .Age}}Age is {{.}}.{{end}}`
	data := person{22}
	tmpl,err := template.New("test").Parse(text)
	if err != nil { panic(err) }
	err = tmpl.Execute(os.Stdout, data)
	if err != nil { panic(err) }
}
```

```bash
$ go run test.go
Age is 22.
```

## template and block

(TODO)

### template

1. `{{template "name"}}`

    The template with the specified name is executed with nil data.

2. `{{template "name" pipeline}}`

    The template with the specified name is executed with dot set to the value of the pipeline.

### block

`{{block "name" pipeline}} T1 {{end}}`
   A block is shorthand for defining a template
   `{{define "name"}} T1 {{end}}`
   and then executing it in place
   `{{template "name" pipeline}}`
   The typical use is to define a set of root templates that are
   then customized by redefining the block templates within.