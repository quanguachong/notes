# Introduction for package net/http

Package http provides HTTP client and server implementations.

## Overview

Get, Head, Post, and PostForm make HTTP(or HTTPS) requests:

```go
resp, err := http.Get("http://example.com/")
...
resp, err := http.Post("http://example.com/upload", "image/jpeg", &buf)
...
resp, err := http.PostForm("http://example.com/form",
	url.Values{"key": {"Value"}, "id": {"123"}})
```

--------------------------------------

The client must close the response body when finished with it:

```go
resp, err := http.Get("http://example.com/")
if err != nil {
	// handle error
}
defer resp.Body.Close()
body, err := ioutil.ReadAll(resp.Body)
// ...
```

--------------------------------------

For control over HTTP client headers, redirect policy, and other settings, create a Client:

```go
client := &http.Client{
	CheckRedirect: redirectPolicyFunc,
}

resp, err := client.Get("http://example.com")
// ...

req, err := http.NewRequest("GET", "http://example.com", nil)
// ...
req.Header.Add("If-None-Match", `W/"wyzzy"`)
resp, err := client.Do(req)
// ...
```

For control over proxies, TLS configuration, keep-alives, compression, and other settings, create a Transport: 

```go
tr := &http.Transport{
	MaxIdleConns:       10,
	IdleConnTimeout:    30 * time.Second,
	DisableCompression: true,
}
client := &http.Client{Transport: tr}
resp, err := client.Get("https://example.com")
```

Clients and Transports are safe for concurrent use by multiple goroutines and for efficiency should only be created once and re-used. 

---------------------------------------

More control over the server's behavior is available by creating a custom Server:

```go
s := &http.Server{
	Addr:           ":8080",
	Handler:        myHandler,
	ReadTimeout:    10 * time.Second,
	WriteTimeout:   10 * time.Second,
	MaxHeaderBytes: 1 << 20,
}
log.Fatal(s.ListenAndServe())
```

--------------------------------------

**ListenAndServe** starts an HTTP server with a given address and handler. The handler is usually nil, which means to use **DefaultServeMux**. Handle and HandleFunc add handlers to **DefaultServeMux**: 

```go
http.Handle("/foo", fooHandler)

http.HandleFunc("/bar", func(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
})

log.Fatal(http.ListenAndServe(":8080", nil))
```

## Example

```go
package main

import (
    "fmt"
    "log"
    "net/http"
)

func myhandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
}

func main() {
    http.HandleFunc("/", myhandler)
    log.Fatal(http.ListenAndServe(":8080", nil))
}
```

```bash
$ go run test.go

---------------

$ curl http://localhost:8080/monkeys
Hi there, I love monkeys!
```


1. `http.HandlerFunc("/", handler)` tells the http package to handler all requests to the web root("/") with myhandler. It registers myhandler for the root("/") in the **DefaultServeMux**.

2. `http.ListenAndServe(":8080", nil)` specifies listening on port 8080. `nil` means it use **DefaultServeMux**. ListenAndserve return an error when an unexpected error occurs, we use log.Fatal to log the error.

3. `func myhandler(w http.ResponseWriter, r *http.Request){}` is an argument for http.HandleFunc

    http.ResponseWriter w assembles the HTTP server's response, we send data to the HTTP client by writing to it.
    ```go
    type ResponseWriter interface{
        Header() Header
        Write([]byte) (int, error)
        WriteHeader(statusCode int)
    }
    ```

    http.Request r is a data structure that represents the client HTTP request.
    ```go
    type Request struct{
        ...
        URL *url.URL
        ...
    }
    ```


    