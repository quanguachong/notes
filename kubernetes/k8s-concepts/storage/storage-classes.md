# Storage Classes

Catalog:

* [Introduction](#Introduction)
* [The StorageClass Resource](#The-StorageClass-Resource)
    * [Provisioner](#Provisioner)
    * [Reclaim Policy](#Reclaim-Policy)
    * [Mount Options](#Mount-Options)
* [Parameters](#Parameters)
    * [Glusterfs](#Glusterfs)
    * [local](#local)
## Introduction

A **StorageClass** provides a way for administrators to describe the "classes" of storage they offer.

## The StorageClass Resource

Each StorageClass contains the fields **provisioner**, **parameters**, and **reclaimPolicy**, which are used when a PersistentVolume belonging to the class needs to be dynamically provisioned.

The name of a StorageClass object is **significant**, and is how users can request a particular class. Administrators set the name and other parameters of a class when first creating StorageClass objects, and the objects **cannot be updated** once they are created.

Example:
```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Retain
mountOptions:
  - debug
```

### Provisioner

This field must be specified. Storage classes have a provisioner that determines what volume plugin is used for provisioning PVs. 

The list of Volume Plugin(part, for more see [Here](https://kubernetes.io/docs/concepts/storage/storage-classes/#provisioner))

|Volume Plugin     | Internal Provisioner  |  Config Example       |
|------------------|-----------------------|-----------------------|
|NFS               |          -            |            -          |
|Glusterfs         |         yes           |[Glusterfs](#glusterfs)|
|StorageOS         |         yes           |         -             |
|Local             |          -            |[Local](#Local)        |
|...               |         ...           |        ...            |

Internal Provisioner's name is prefixed with "kubernetes.io" and shipped alongside Kubernetes.

We can also run and specify external provisioers, which are independent programs that follow a specification defined by Kubernetes.

### Reclaim Policy

Can be either **Delete** or **Retain**(if not set,it will default to **Delete**)

### Mount Options

Persistent Volumes that are dynamically created by a storage class will have the mount options specified in the **mountOptions** field of the class.

If the volume plugin does not support mount options but mount options are specified, provisioning will fail. Mount options are not validated on either the class or PV, so mount of the PV will simply fail if one is invalid.

## Parameters

Storage classes have parameters that describe volumes belonging to the storage class. Different parameters may be accepted depending on the provisioner.

### Glusterfs

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: slow
provisioner: kubernetes.io/glusterfs
parameters:
  resturl: "http://127.0.0.1:8081"
  clusterid: "630372ccdc720a92c681fb928f27b53f"
  restauthenabled: "true" # deprecated
  restuser: "admin"
  secretNamespace: "default"
  secretName: "heketi-secret"
  gidMin: "40000"
  gidMax: "50000"
  volumetype: "replicate:3"
```

Parameters analysis:

1. **resturl**:

    The general format **IPaddress:Port**, Gluster REST service/Heketi service url

2. **restuser**:
    
    Gluster REST service/Heketi user who has access to create volumes in the Gluster Trusted Pool.

3. **secretNamespace, secretName**(optional, omitted for empty password): 

    Identification of Secret instance that contains user password to use when talking to Gluster REST service.

    The provided secret must have type `kubernetes.io/glusterfs`, e.g.:

    ```console
    kubectl create secret generic heketi-secret \
    --type="kubernetes.io/glusterfs" --from-literal=key='opensesame' \
    --namespace=default
    ```

4. **clusterid**(optional):
    
    The ID of the cluster which will be used by Heketi when provisioning the volume. It can also be a list of clusterids.
    
    For example: "8452344e2becec931ece4e33c4674e4e,42982310de6c63381718ccfa6d8cf397".

5. **gidMin,gidMax**(optional):

    The minimum and maximum value of GID range for the storage class. Default is 2000-2147483647.

6. **volumetype**(optional):

    The volume type and its parameters can be configured with this optional value. If the volume type is not mentioned, it’s up to the provisioner to decide the volume type.

    For example:
    * Replica volume: `volumetype: replicate:3` where '3' is replica count.
    * Disperse/EC volume: `volumetype: disperse:4:2` where '4' is data and '2' is the redundancy count.
    * Distribute volume: `volumetype:none`

### Local

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

Local volumes do not support dynamic provisioning yet. However a StorageClass should still be created to delay volume binding until pod scheduling. This is specified by the **WaitForFirstConsumer** volume binding mode.

Delaying volume binding allows the scheduler to consider all of a pod’s scheduling constraints when choosing an appropriate PersistentVolume for a PersistentVolumeClaim.