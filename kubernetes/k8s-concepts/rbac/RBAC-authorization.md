# Using RBAC Authorization

Role-based access control(RBAC) is a method of regulating to computer or network resources based on the roles of individual users within an enterprise.

RBAC uses the API group **rabc.authorization.k8s.io**

## overview

There are four kinds of resources for rbac.

### Role and ClusterRole

A role contains rules that represent a set of permissions. Permissions are purely additive(there are no "deny" rules).

A role can be defined within a namespace with a **Role**, or cluster-wide with a **ClusterRole**.

1. **Role** can only be used to grant access to resources within a single namespace.

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

2. **ClusterRole** can grant more access than Role, because ClusterRole are cluster-scoped, such as:

* namespaced resources(like pods) across all namespaces(needed to run `kuectl get pods --all-namespaces`,for example)
* cluster-scoped resources(like nodes)
* non-resource endpoints

```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  # "namespace" omitted since ClusterRoles are not namespaced
  name: secret-reader
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "watch", "list"]
```

### RoleBinding and ClusterRoleBinding

Bindings can grants permissions defined in a role to a user or a set of users.