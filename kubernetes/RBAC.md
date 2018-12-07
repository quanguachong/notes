# RBAC

Role-based access control(RBAC) is a method of regulating access to computer or network resources based on the roles of individual users within an enterprise.

## Overview

### Role and ClusterRole

In the RBAC API, a role contains rules that represent a set of permissions. Permissions are purely additive. A role can be defined within a namespace with a **Role**, or cluster-wide with a **ClusterRole**.

1. A Role can only be used to grant access to resources within a single namespace. Here’s an example Role in the “default” namespace that can be used to grant read access to pods:

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

2. A ClusterRole can be used to grant the same permissions as a Role, but because they are cluster-scoped, they can also be used to grant access to:

* cluster-scoped resources(like nodes)
* non-resource endpoints(like "/healthz")
* namespaced resources(like pods) across all namespaces

The following ClusterRole can be used to grant read access to secrets in any particular namespace, or across all namespaces:

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

A role binding grants the permissions defined in a role to a user or set of users. It holds a list of subjects (users, groups, or service accounts), and a reference to the role being granted. Permissions can be granted within a namespace with a **RoleBinding**, or cluster-wide with a **ClusterRoleBinding**.

A RoleBinding may reference a Role in the same namespace. The following RoleBinding grants the “pod-reader” role to the user “jane” within the “default” namespace. This allows “jane” to read pods in the “default” namespace.

**roleRef** is how you will actually create the binding. The kind will be either Role or ClusterRole, and the name will reference the name of the specific Role or ClusterRole you want. In the example below, this RoleBinding is using roleRef to bind the user “jane” to the Role created above named pod-reader.

```yaml
# This role binding allows "jane" to read pods in the "default" namespace.
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: jane # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
```

A **RoleBinding** may also reference a ClusterRole to grant the permissions to namespaced resources defined in the ClusterRole within the RoleBinding’s namespace. This allows administrators to define a set of common roles for the entire cluster, then reuse them within multiple namespaces.

For instance, even though the following RoleBinding refers to a ClusterRole, “dave” (the subject, case sensitive) will only be able to read secrets in the “development” namespace (the namespace of the RoleBinding).

```yaml
# This role binding allows "dave" to read secrets in the "development" namespace.
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-secrets
  namespace: development # This only grants permissions within the "development" namespace.
subjects:
- kind: User
  name: dave # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```

Finally, a ClusterRoleBinding may be used to grant permission at the cluster level and in all namespaces. The following ClusterRoleBinding allows any user in the group “manager” to read secrets in any namespace.

```yaml
# This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-secrets-global
subjects:
- kind: Group
  name: manager # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```

### Referring to Resources

1. Some Kubernetes APIs involve a "subresource", such logs for a pod. The URL for pods logs endpoint is:

```bash
GET /api/v1/namespaces/{namespace}/pods/{name}/log
```

To allow a subject to read both pods and pod logs in Role:

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-and-pod-logs-reader
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list"]
```
2. Resources can be referred to by name for certain requests through the **resourceNames** list.

When specified, **verbs** can be "get","delete","update" and "patch" for individual instances of a resource.

the verbs must not be "list", "watch" ,"create" and "deletecollection"

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: configmap-updater
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  resourceNames: ["my-configmap"]
  verbs: ["update", "get"]
```

### Aggregated ClusterRoles

ClusterRoles can be created by combining other ClusterRoles using an **aggregationRule**. The permissions of aggregated ClusterRoles are controller-managed, and filled in by unioning the rules of any ClusterRole that matches the provided label selector.

Example:

```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: monitoring
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.example.com/aggregate-to-monitoring: "true"
rules: [] # Rules are automatically filled in by the controller manager.
```

the following ClusterRole that matches the label selector will add rules to the ClusterRole above.
```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: monitoring-endpoints
  labels:
    rbac.example.com/aggregate-to-monitoring: "true"
# These rules will be added to the "monitoring" role.
rules:
- apiGroups: [""]
  resources: ["services", "endpoints", "pods"]
  verbs: ["get", "list", "watch"]
```

### Referring to Subjects

A **RoleBinding** or **ClusterRoleBinding** binds a role to subjects. Subjects can be groups,users or serviceaccounts.

Role Binding Examples

1. For a user named "alice":

```yaml
subjects:
- kind: User
  name: "alice@example.com"
  apiGroup: rbac.authorization.k8s.io
```

2. For a group named "fronted-admins"

```yaml
subjects:
- kind: Group
  name: "frontend-admins"
  apiGroup: rbac.authorization.k8s.io
```

3. For the service account named default in the kube-system namespace:

```yaml
subjects:
- kind: ServiceAccount
  name: default
  namespace: kube-system
```
4. For all service accounts in the "qa" namespace:

```yaml
subjects:
- kind: Group
  name: system:serviceaccounts:qa
  apiGroup: rbac.authorization.k8s.i
```

5. For all service accounts

```yaml
subjects:
- kind: Group
  name: system:serviceaccounts
  apiGroup: rbac.authorization.k8s.i
```

6. For different users.

* for all authenticated users

```yaml
subjects:
- kind: Group
  name: system:authenticated
  apiGroup: rbac.authorization.k8s.io
```
* for all unauthenticated users

```yaml
subjects:
- kind: Group
  name: system:unauthenticated
  apiGroup: rbac.authorization.k8s.io
```

* for all users

```yaml
subjects:
- kind: Group
  name: system:authenticated
  apiGroup: rbac.authorization.k8s.io
- kind: Group
  name: system:unauthenticated
  apiGroup: rbac.authorization.k8s.io
```