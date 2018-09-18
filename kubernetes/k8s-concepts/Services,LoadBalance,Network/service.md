# Service in kubernetes

1. ServiceTypes:specify what kind of service you want,the default is ClusterIP.

    *ClusterIP:Exposes the service on a cluster-internal IP.Choosing this value makes the service only reachable from within the cluster.This is the default ServiceType.

    *NodePort:Exposes the service on each Node's IP at a static port(the NodePort).A ClusterIP service, to which the NodePort service will route,is automatically created.You'll be able to contact the NodePort service, from outside the cluster,by requesting <NodeIP>:<NodePort>.

    *LoadBalancer:Exposes the service externally using a cloud provider's load balancer. NodePort and ClusterIP services,to which the external load balancer will route,are automatically created.

    *ExternalName:Maps the service to the contents of the externalName field (e.g. foo.bar.example.com), by returning a CNAME record with its value. No proxying of any kind is set up. This requires version 1.7 or higher of kube-dns.g

2. Services with selectors and without selectors
    (1)
    ```yaml
    kind: Service
    apiVersion: v1
    metadata:
        name: my-service
    spec:
        selector:
            app: MyApp
        ports:
        - protocol: TCP
          port: 80
          targetPort: 9376
    ```
    This specification will create a new **Service** object which targets TCP port 9367 on any Pod with the "app=MyApp" label.This **Service** will also be assigned an IP address,which is used by service proxies.The selector will be evaluated continuously and the results will be POSTed to an **Endpoints** object also named "my-service"

    (2)
    ```yaml
    kind: Service
    apiVersion: v1
    metadata:
      name: my-service
    spec:
      ports:
      - protocol: TCP
        port: 80
        targetPort: 9376

    kind: Endpoints
    apiVersion: v1
    metadata:
      name: my-service
    subsets:
      - addresses:
          - ip: 1.2.3.4
        ports:
          - port: 9376
    ```
    service without selector will not auto-create **Endpoints**,manually map the service to your own endpoints.

3. kube-proxy: Every node in a Kubernetes cluster runs a **kube-proxy**. **kube-proxy** is responsible for implementing a form of virtual IP for Services of type other than ExternalName.

    *Proxy-mode:userspace

    (1)kube-proxy watch addition and removal of **Service** and **Endpoints** objects.
    (2)It opens a port(randomly) for each **Service** on local node.Any connections to this "proxy port" will be proxied to one of the Service's backend Pods.
    (3)Lastly, it installs iptables rules to redirect the traffic(to the **Service's clusterIP** which is virtual and **port**) to the proxy port.
    (4)By default, the choice of backend is round robin

    *Proxy-mode:iptables

    (1)kube-proxy watch addition and removal of **Service** and **Endpoints** objects.
    (2)For **each** Service, it installs iptables rules which capture traffic to the Service’s clusterIP (which is virtual) and Port and redirects that traffic to one of the Service’s backend sets
    (3)For **each** Endpoints object, it installs iptables rules which select a backend Pod
    (4)By default, the choice of backend is random.