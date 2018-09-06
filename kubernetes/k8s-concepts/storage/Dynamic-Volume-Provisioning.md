# Dynamic Volume Provisioning

Dynamic volume provisioning allows storage volumes to be created on-demand. It automatically provisions storage when it is requested by users.

## Background

The implementation of dynamic volume provisioning is based on the API object **StorageClass** from the API group storage.k8s.io.

A cluster administrator can define as many **StorageClass** as needed.

End users don't have to worry about the complexity and nuances of how storage is provisioned, but still have the ability to select from multiple storage options.

## Enabling Dynamic Provisioning

To enable dynamic provisioning, a cluster administrator needs to pre-create one or more StorageClass objects for users.

Two StorageClasses objects are created below:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: slow
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-standard
```

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
```

## Using Dynamic Provisioning

Users request dynamically provisioned storage by including a storage class in their PersistentVolumeClaim

To select the `fast` storage class, use the following PVC:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: claim1
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: fast
  resources:
    requests:
      storage: 30Gi
```

## Defaulting Behavior

Claims can also be dynamically provisioned if they specify no storage class. A cluster administrator can enable this behavior by:
* Marking one StorageClass object as default
* Making sure that the DefaultStorageClass admission controller is enabled on the API server.

Notes:

* An administrator can mark a specific **StorageClass** as default by adding the `storageclass.kubernetes.io/is-default-class` annotation to it.
* A PVC without specified **storageClassName** will be automatically added the storageClassName field pointing to the default storage class.
* There can be at most one default storageclass on a cluster, or a PVC without specified storageClassName  cannot be created.
