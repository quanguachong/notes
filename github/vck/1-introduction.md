# Volume Controller for Kubernetes(VCK)

## Overview

    This project provides basic volume and data management in Kubernetes v1.9+ using custom resource definitions (CRDs), custom controllers, volumes and volume sources. It also establishes a relationship between volumes and data and provides a way to abstract the details away from the user. When using VCK, users are expected to only interact with custom resources (CRs).

## NodeAffinity (pod's spec in fact)

    1.overview: NodeAffinity is similar to nodeSelector,allows you to constrain which nodes your pod is eligible to be scheduled on,based on labels on the node.

    2.kinds:
        (1)requiredDuringSchedulingIgnoredDuringExecution:
        must be met
        (2)preferredDuringSchedulingIgnoredDuringExecution:
        try to enforce but will not guarantee

        'IgnoredDuringExecution' means if labels on nodes change at runtime and no longer met the affinity rules,the pod will still continue to run on the node.

    3.specified field:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: with-node-affinity
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/e2e-az-name
            operator: In
            values:
            - e2e-az1
            - e2e-az2
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
  containers:
  - name: with-node-affinity
    image: k8s.gcr.io/pause:2.0
```