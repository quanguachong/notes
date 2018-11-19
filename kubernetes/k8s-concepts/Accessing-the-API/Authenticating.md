# Authenticating

## Users in kubernetes

Two categories fo users: **service accounts** managed bu kubernetes, and **normal users**.

Service account are managed by Kubernetes API. Service accounts are tied to a set of credential stored as **Secrets**.

API requests are tied to either a normal user or a service account, or are treated as anonymous requests. This means every process inside or outside the cluster, from a human user typing kubectl on a workstation, to kubelets on nodes, to members of the control plane, must authenticate when making requests to the API server, or be treated as an anonymous user.

## Authentication strategies

Kubernetes uses followings to authenticate API requests through authentication plugins:
* client certificates
* bearer tokens
* authenticating proxy
* HTTP basic auth

Multiple authenticatoin methods:
* service account tokens for service accounts
* ...

## Putting a Bearer Token in a Request

```bash
  curl -X GET -H "Authorization: Bearer $TS_AUTH_TOKEN" \
  http://localhost:9090/api/v1/volumemanager
```