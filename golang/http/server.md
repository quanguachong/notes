# serve.go

In net/http/server.go

## type struct and interface

### Server

A Server defines parameters for running an HTTP server.

The zero value for Server is a valid configuration. 


```go
type Server struct {
    Addr    string  // TCP address to listen on, ":http" if empty
    Handler Handler // handler to invoke, http.DefaultServeMux if nil

    // TLSConfig optionally provides a TLS configuration for use
    // by ServeTLS and ListenAndServeTLS. Note that this value is
    // cloned by ServeTLS and ListenAndServeTLS, so it's not
    // possible to modify the configuration with methods like
    // tls.Config.SetSessionTicketKeys. To use
    // SetSessionTicketKeys, use Server.Serve with a TLS Listener
    // instead.
    TLSConfig *tls.Config

    // ReadTimeout is the maximum duration for reading the entire
    // request, including the body.
    //
    // Because ReadTimeout does not let Handlers make per-request
    // decisions on each request body's acceptable deadline or
    // upload rate, most users will prefer to use
    // ReadHeaderTimeout. It is valid to use them both.
    ReadTimeout time.Duration

    // ReadHeaderTimeout is the amount of time allowed to read
    // request headers. The connection's read deadline is reset
    // after reading the headers and the Handler can decide what
    // is considered too slow for the body.
    ReadHeaderTimeout time.Duration

    // WriteTimeout is the maximum duration before timing out
    // writes of the response. It is reset whenever a new
    // request's header is read. Like ReadTimeout, it does not
    // let Handlers make decisions on a per-request basis.
    WriteTimeout time.Duration

    // IdleTimeout is the maximum amount of time to wait for the
    // next request when keep-alives are enabled. If IdleTimeout
    // is zero, the value of ReadTimeout is used. If both are
    // zero, ReadHeaderTimeout is used.
    IdleTimeout time.Duration

    // MaxHeaderBytes controls the maximum number of bytes the
    // server will read parsing the request header's keys and
    // values, including the request line. It does not limit the
    // size of the request body.
    // If zero, DefaultMaxHeaderBytes is used.
    MaxHeaderBytes int

    // TLSNextProto optionally specifies a function to take over
    // ownership of the provided TLS connection when an NPN/ALPN
    // protocol upgrade has occurred. The map key is the protocol
    // name negotiated. The Handler argument should be used to
    // handle HTTP requests and will initialize the Request's TLS
    // and RemoteAddr if not already set. The connection is
    // automatically closed when the function returns.
    // If TLSNextProto is not nil, HTTP/2 support is not enabled
    // automatically.
    TLSNextProto map[string]func(*Server, *tls.Conn, Handler)

    // ConnState specifies an optional callback function that is
    // called when a client connection changes state. See the
    // ConnState type and associated constants for details.
    ConnState func(net.Conn, ConnState)

    // ErrorLog specifies an optional logger for errors accepting
    // connections, unexpected behavior from handlers, and
    // underlying FileSystem errors.
    // If nil, logging is done via the log package's standard logger.
    ErrorLog *log.Logger
    // contains filtered or unexported fields
}
```

### ServeMux

ServeMux is an HTTP request multiplexer.

It matches the URL of each incoming request against a list of registered patterns and calls the handler for the pattern that most closely matches the URL.

```go
// DefaultServeMux is the default ServeMux used by Serve.
var DefaultServeMux = &defaultServeMux

var defaultServeMux ServeMux

type ServeMux struct {
	mu    sync.RWMutex
	m     map[string]muxEntry
	hosts bool // whether any patterns contain hostnames
}

type muxEntry struct {
	h       Handler
	pattern string
}
```

### Handler

A Handler responds to an HTTP request.

```go
type Handler interface {
    ServeHTTP(ResponseWriter, *Request)
}

type ResponseWriter interface{
    Header() Header
    Write([]byte) (int, error)
    WriteHeader(statusCode int)
}
```

Considering myhandler is `func(ResponseWriter, *Request)`

1. You can use `http.HandleFunc("/",myhandler)`

2. You can use `http.HandlerFunc(myhandler)` to let myhandler satifies the `type Handler interface`
   
   So you can use `http.Handle("/",http.HandlerFunc(myhandler))`

e.g.: the following codes act the same

```go
func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
}

func main() {
    http.Handle("/", http.HandlerFunc(handler))
    log.Fatal(http.ListenAndServe(":8080", nil))
}
```
```go
func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
}

func main() {
    http.HandleFunc("/",handler)
    log.Fatal(http.ListenAndServe(":8080", nil))
}
```

## Methods

http.HandleFunc(...)
```go
// HandleFunc registers the handler function for the given pattern
// in the DefaultServeMux.
// The documentation for ServeMux explains how patterns are matched.
func HandleFunc(pattern string, handler func(ResponseWriter, *Request)) {
	DefaultServeMux.HandleFunc(pattern, handler)
}
```

-----------------------------------------------------

http.Handle(...)
```go
// Handle registers the handler for the given pattern
// in the DefaultServeMux.
// The documentation for ServeMux explains how patterns are matched.
func Handle(pattern string, handler Handler) { DefaultServeMux.Handle(pattern, handler) }
```

----------------------------------------------------

DefaultServeMux.Handler(pattern,handler) use the **ServeMux.Handle**
```go
// Handle registers the handler for the given pattern.
// If a handler already exists for pattern, Handle panics.
func (mux *ServeMux) Handle(pattern string, handler Handler){...}
```
