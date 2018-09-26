# usual methods in package github.com/emicklei/go-restful

## Get parameter from url

QueryParameter and PathParameter

```go
import restful "github.com/emicklei/go-restful"
// QueryParameter
func (...)ListHandler(req *restful.Request,resp *restful.Response){
    // Can capture the parameter after the ?
    // The code in WebService is:
    // apiv1.Route(apiv1.GET("seldon").To(seldon.Client.ListHandler))
    //
    // For the following request:
    // ```bash
    // curl -X GET -H "Authorization: Bearer $TS_AUTH_TOKEN" \
    // http://localhost:9090/api/v1/seldon?ns=default
    // ```
    // the ns's value is "default"
    ns := req.QueryParameter("ns")
    ...
}

-----------------------------------------------

import restful "github.com/emicklei/go-restful"
// PathParameter
func (...)DeleteHandler(req *restful.Request,resp *restful.Response){

    // Can capture the parameter in path
    // The corresponding fields are defined in WebService
    // apiv1.Route(apiv1.DELETE("seldon/{namespace}/{sd-name}").To(seldon.Client.DeleteHandler))
    //
    // For the following request:
    // ```bash
    // curl -X DELETE -H "Authorization: Bearer $TS_AUTH_TOKEN" \
    // http://localhost:9090/api/v1/seldon/default/sd-name
    // ```
    // ns's value is "default", sd's value is "sd-name"
    ns := req.PathParameter("namespace")
    sd := req.PathParameter("sd-name")
    ...
}
```

## Get value from request

ReadEntity

```go
import restful "github.com/emicklei/go-restful"

type GetRqe struct{
    UserID string `json:"user_id,omitempty"`
}
// ReadEntity
func (...)ListNotifications(req *restful.Request,resp *restful.Response){
    getReq := &GetReq{}
    // Get the body of req to getReq
    // 
    // The codes in WebService is:
    // apiv1.Route(apiv1.POST("notification/list").To(handler.Notification.ListNotifications))
    err := req.ReadEntity(getReq)
    ...
}
```

If you use the following command, you can get the getReq to be{UserID: ldap-test} in upper func ListNotifications.
```bash
$ curl -X POST -H "Authorization: Bearer $TS_AUTH_TOKEN" \
  -H "Content-Type:application/json"  \
  -d '{"user_id": "ldap-test"}' \
  http://localhost:9099/api/v1/notification/list
```

## Write value to response

```go
import restful "github.com/emicklei/go-restful"

// AddHeader is a shortcut for .Header().Add(header,value)
// It adds the key, value pair to the header.
// It appends to any existing values associated with key.
resp.AddHeader("Content-Type","text/plain")

// WriteErrorString is a convenience method for an error status with the actual error
resp.WriteErrorString(http.StatusNotFound, "User could not be found")

// WriteHeaderAndJson is a convenience method for writing the status and a value in Json with a given Content-Type.
// It uses the standard encoding/json package for marshalling the value ; not using a registered EntityReaderWriter.
//
//func (r *Response) WriteHeaderAndJson(status int, value interface{}, contentType string) error
resp.WriteHeaderAndJson(http.StatusBadRequest, data, restful.MIME_JSON)
```