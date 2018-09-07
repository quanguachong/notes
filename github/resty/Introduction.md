# Introduction to package github.com/go-resty/testy

Package resty provides simple HTTP and REST client for Go inspired by Ruby rest-client.

## Client

resty has a default client

```go
// DefaultClient of resty
var DefaultClient *Client
```

```go
// Client type is used for HTTP/RESTful global values
// for all request raised from the client
type Client struct {
    HostURL               string
    QueryParam            url.Values
    FormData              url.Values
    Header                http.Header
    UserInfo              *User
    Token                 string
    Cookies               []*http.Cookie
    Error                 reflect.Type
    Debug                 bool
    DisableWarn           bool
    AllowGetMethodPayload bool
    Log                   *log.Logger
    RetryCount            int
    RetryWaitTime         time.Duration
    RetryMaxWaitTime      time.Duration
    RetryConditions       []RetryConditionFunc
    JSONMarshal           func(v interface{}) ([]byte, error)
    JSONUnmarshal         func(data []byte, v interface{}) error
    // contains filtered or unexported fields
}
```

## Methods

When invoking resty.SetHTTPMode(), it will use the DefaultClient.SetHTTPMode(). The same when invoking others.

1. SetHTTPMode()

    ```go
    // SetHTTPMode method sets go-resty mode into HTTP. See `Client.SetMode` for more information.
    func SetHTTPMode() *Client {
	return DefaultClient.SetHTTPMode()
    }

    --------------------------
    
    // SetHTTPMode method sets go-resty mode to 'http'
    func (c *Client) SetHTTPMode() *Client {
	return c.SetMode("http")
    }
    ```

2. SetCertificates()

    ```go
    // SetCertificates method helps to set client certificates into resty conveniently.
    func (c *Client) SetCertificates(certs ...tls.Certificate) *Client{..}
    ```

3. SetTLSClientConfig()

    ```go
    // SetTLSClientConfig method sets TLSClientConfig for underling client Transport.
    // Note: This method overwrites existing `TLSClientConfig`.
    func (c *Client) SetTLSClientConfig(config *tls.Config) *Client{...}
    ```

    Example:
    ```go
    // One can set custom root-certificate.
    resty.SetTLSClientConfig(&tls.Config{ RootCAs: roots })

    // or One can disable security check (https)
    resty.SetTLSClientConfig(&tls.Config{ InsecureSkipVerify: true })
    ```
