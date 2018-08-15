# Ingress

An API object that manages external access to the services in a cluster,typically HTTP.

## Terminology

* Node:A single virtual or physical machine in a Kubernetes cluster.

* Cluster: A group of nodes firewalled from the internet, that are the primary compute resources managed by Kubernetes.

* Edge router: A router that enforces the firewall policy for your cluster. This could be a gateway managed by a cloud provider or a physical piece of hardware.

* Cluster network: A set of links, logical or physical, that facilitate communication within a cluster according to the Kubernetes networking model. Examples of a Cluster network include Overlays such as flannel or SDNs such as OVS.

* Service: A Kubernetes Service that identifies a set of pods using label selectors. Unless mentioned otherwise, Services are assumed to have virtual IPs only routable within the cluster network

## Synopsis

Typically, services and pods have IPs only routable by the cluster network.

An Ingress is a collection of rules that allow inbound connections to reach the cluster services.

It can be configured to give services externally-reachable URLs,load balance traffic, terminate SSL, offer name based virtual hosting, and more.

## The Ingress Resource

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /testpath
        backend:
          serviceName: test
          servicePort: 80
```

POSTing this minimal Ingress to APIServer will have on effect if you have not configured an **Ingress controller**.

## Ingress controllers

In order for the Ingress resource to work, the cluster must have an Ingress controller running.

This is unlike other types of controllers, which typically run as part of the kube-controller-manager binary, and which are typically started automatically as part of cluster creation. Choose the ingress controller implementation that best fits your cluster, or implement a new ingress controller.

* Kubernetes currently supports and maintains GCE and nginx controllers.
* F5 Networks provides support and maintenance for the F5 BIG-IP Controller for Kubernetes.
* and so on

## Types of Ingress

### Single Service Ingress

There are existing Kubernetes concepts that allow you to expose a single Service, however you can do so through an Ingress as well, by specifying a default backend with no rules.

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
spec:
  backend:
    serviceName: testsvc
    servicePort: 80
```

After creation

```bash
$ kubectl get ing
NAME                RULE          BACKEND        ADDRESS
test-ingress        -             testsvc:80     107.178.254.228
```

Where 107.178.254.228 is the IP allocated by the Ingress controller to satisfy this Ingress. The RULE column shows that all traffic sent to the IP are directed to the Kubernetes Service listed under BACKEND.

### Simple fanout

As described previously, Pods within kubernetes have IPs only visible on the cluster network, so we need something at the edge accepting ingress traffic and proxying it to the right endpoints. This component is usually a highly available loadbalancer. An Ingress allows you to keep the number of loadbalancers down to a minimum. 

For example, a setup like:

```bash
foo.bar.com -> 178.91.123.132 -> / foo    s1:80
                                 / bar    s2:80
```

Ingress as below:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /foo
        backend:
          serviceName: s1
          servicePort: 80
      - path: /bar
        backend:
          serviceName: s2
          servicePort: 80
```

After creation

```bash
$ kubectl get ing
NAME      RULE          BACKEND   ADDRESS
test      -
          foo.bar.com
          /foo          s1:80
          /bar          s2:80
```

The Ingress controller will provision an implementation specific loadbalancer that satisfies the Ingress, as long as the services (s1, s2) exist. When it has done so, you will see the address of the loadbalancer under the last column of the Ingress.

### Name based virtual hosting

Name-based virtual hosts use multiple host names for the same IP address.

```bash
foo.bar.com --|                 |-> foo.bar.com s1:80
              | 178.91.123.132  |
bar.foo.com --|                 |-> bar.foo.com s2:80
```

Ingress as below

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - backend:
          serviceName: s1
          servicePort: 80
  - host: bar.foo.com
    http:
      paths:
      - backend:
          serviceName: s2
          servicePort: 80
```

**Default Backends**: An Ingress with no rules, like the one shown in the previous section, sends all traffic to a single default backend. You can use the same technique to tell a loadbalancer where to find your website’s 404 page, by specifying a set of rules and a default backend. Traffic is routed to your default backend if none of the Hosts in your Ingress match the Host in the request header, and/or none of the paths match the URL of the request.

### TLS

You can secure an Ingress by specifying a secret that contains a TLS private key and cretificate. Currently the Ingress only supports a single TLS port, 443, and assumes TLS termination.

The TLS secret must contain keys named **tls.crt** and **tls.key**, e.g.:

```yaml
apiVersion: v1
data:
  tls.crt: base64 encoded cert
  tls.key: base64 encoded key
kind: Secret
metadata:
  name: testsecret
  namespace: default
type: Opaque
```

Referencing this secret in an Ingress will tell the Ingress controller to secure the channel from the client to the loadbalancer using TLS:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: no-rules-map
spec:
  tls:
  - secretName: testsecret
  backend:
    serviceName: s1
    servicePort: 80
```

Notes: there is a gap between TLS features supported by various Ingress controllers.

### Loadbalancing

An Ingress controller is bootstrapped with some balancing policy settings that it applies to all Ingress, such as the load balancing algorithm, backend weight scheme, and others.