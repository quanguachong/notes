# Grammar

Catalog:
* [File example](#File-example)
* [Format spaces](#Format-spaces)
* [Arguments](#Arguments)

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

## Arguments


