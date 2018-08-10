# Logging Architecture

logs should have a separate storage and lifecycle independent of nodes,pods or containers.

This concept is called cluster-level-logging.

Cluster-level looging requires a separate backend to store, analyze, and query logs.

## Basic logging in Kubernetes

kubernetes can collect stdout and stderr as logs

```bash
$ kubectl logs <pod_name>
# show the pod's logs here

$ kubectl logs <pod_name> <container_name>
# show logs of the container in the pod
```

e.g.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: counter
spec:
  containers:
  - name: count
    image: busybox
    args: [/bin/sh, -c,
            'i=0; while true; do echo "$i: $(date)"; i=$((i+1)); sleep 1; done']
```

```bash
$ kubectl create -f counter.yaml

pod "counter" created

$ kubectl logs counter

0: Thu Aug  9 11:12:21 UTC 2018
1: Thu Aug  9 11:12:22 UTC 2018
2: Thu Aug  9 11:12:23 UTC 2018
3: Thu Aug  9 11:12:24 UTC 2018
```

## Logging at the node level

Everything a containerized application writes to **stdout** and **stderr** is handled and redirected somewhere by a container engine.

Note: the Docker json logging treats each line as a separate message.

By default, if a container restarts, the kubelet keeps one terminated container with its logs. If a pod is evicted from the node, all corresponding containers are also evicted, along with their logs.

https://kubernetes.io/docs/concepts/cluster-administration/logging/

https://akomljen.com/get-kubernetes-logs-with-efk-stack-in-5-minutes/

https://banzaicloud.com/blog/k8s-logging/