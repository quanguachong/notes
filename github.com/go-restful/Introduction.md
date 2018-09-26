# Introduction for package github.com/emicklei/go-restful

Package restful , a lean package for creating REST-style WebServices without magic.

## WebServices and Routes

A WebService has a collection of Route objects that dispatch incoming Http Requests to a function calls.

Typically, a WebService has a root path (e.g. /users) and defines common MIME types for its routes.

WebServices must be added to a container (see below) in order to handler Http requests from a server.

A Route is defined by a HTTP method, an URL path and (optionally) the MIME types it consumes (Content-Type) and produces (Accept). This package has the logic to find the best matching Route and if found, call its Function.

```go
ws := new(restful.WebService)
ws.Path("/users").
   Consumes(restful.MIME_JSON, restful.MIME_XML).
   Produces(restful.MIME_JSON, restful.MIME_XML)
ws.Route(ws.GET("/{user-id}").To(u.findUser))  // u is a UserResource
...

// GET http://localhost:8080/users/1
func (u UserResource) findUser(request *restful.Request, response *restful.Response) {
	id := request.PathParameter("user-id")
	...
}
```

The (*Request, *Response) arguments provide functions for reading information from the request and writing information back to the response.

## Containers

A Container holds a collection of WebServices, Filters and a http.ServeMux for multiplexing http requests.

Using the statements "restful.Add(...) and restful.Filter(...)" will register WebServices and Filters to the Default Container. The Default container of go-restful uses the http.DefaultServeMux.

You can create your own Container and create a new http.Server for that particular container.
```go
container := restful.NewContainer()
server := &http.Server{Addr: ":8081", Handler: container}
```

## Filters

