# Persistent Volumes(ab. PV)

## Introduction

1. PersistentVolume(PV):
    * a piece of storage in the cluster provisioned by an administrator
    * API resource
    * independent of any individual pod who uses the PV
    * captures implementation of the storages(NFS, iSCSI ...)

2. PersistentVolumeClaim(PVC):
    * a request for storage by a user
    * PVCs consume PV resources

## Lifecycle

1. Provisioning: PVs may be provisioned statically or dynamically
    * Static: administrator creates PVs which carry available storage, PVs are ready for consumption

    * Dynamic: no PVs matches a PVC, the cluster dynamically provision a volume specially for the PVC based on

      StorageClasses(the PVC must request a storage class, and the class must be ready for dynamic provisioning)

      Notes: enable the DefaultStorageClass on the API server to enable dynamic storage provisioning based on storage class

2. Binding: 

    A PVC to PV binding is a one-to-one mapping.

    A control loop in the master watches for new PVCs, finds a matching PV and binds them together.

    If a PV was dynamically provisioned for a new PVC, the loop will always bind the PV to the PVC.Otherwise, the user will always get at least what they asked for, but the volume may be in excess of what was requested. Once bound, PersistentVolumeClaim binds are exclusive.   Claims will remain unbound indefinitely if a matching volume does not exist.

3. Using:

    Pods use claims as volumes, the cluster inspects the claim to find the bound volume and mounts that volume for a pod.

4. Storage Object in Use Protection

    The purpose of the Storage Object in Use Protection feature is to ensure PVCs in active use by a pod and PVs that are bound to PVCs are not removed from the system as this may result in data loss.

    When the Storage Object in Use Protection feature is enabled, if a user deletes a PVC in active use by a pod, the PVC is not removed immediately. The same to PV.

5. Reclaiming

    When a user is done with their volume, they can delete the PVC objects from the API which allows reclamation of the resource. The reclaim policy for a PersistentVolume tells the cluster what to do with the volume after it has been released of its claim. Currently, volumes can either be Retained, Recycled or Deleted.

    * **Retain**

    The **Retain** reclaim policy allows for manual reclamation of the resource. When the **PersistentVolumeClaim** is deleted,the **PersistentVolume** still exists and the volume is considered “released”. But it is not yet available for another claim because the previous claimant’s data remains on the volume. An administrator can manually reclaim the volume with the following steps:

    1. Delete the PV, the associated storage asset in external infrastructure still exists after the PV is deleted.

    2. Manually clean up the data on the associated storage asset accordingly.

    3. Manually delete the associated storage asset, or if you want to reuse the same storage asset, create a new PV with the storage asset definition.

    * **Delete**

    For volume plugins that support the **Delete** reclaim policy, deletion removes both the **PersistentVolume** object from Kubernetes, as well as the associated storage asset in the external infrastructure, such as an AWS EBS,GCE PD, Azure Disk, or Cinder volume.

    Volumes that were dynamically provisioned inherit the reclaim policy of their StorageClass, which defaults to **Delete**. The administrator should configure the **StorageClass** according to users’ expectations, otherwise the PV must be edited or patched after it is created.

    * **Recycle**

    Warning: The Recycle reclaim policy is deprecated. Instead, the recommended approach is to use dynamic provisioning.

## Types of Persistent Volumes

* GCEPersistentDisk
* AWSElasticBlockStore
...

## Persistent Volumes

Each PV contains a spec and status, which is the specification and status of the volume.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```

1. Capacity

    a PV has a specific storage capacity, which is set using .spec.capacity

2. Volume Mode

    To enable this feature, enable the **BlockVolume** feature gate on the apiserver, controller-manager and the kubelet

    Now, you can set the value of **volumeMode** to **raw** to use a raw block device, or **filesystem** to use a filesystem. filesystem is the default if the value is omitted. This is an optional API parameter.

3. Access Modes

    different Volume Plugins have different Access Modes

    * ReadWriteOnce – the volume can be mounted as read-write by a single node
    * ReadOnlyMany – the volume can be mounted read-only by many nodes
    * ReadWriteMany – the volume can be mounted as read-write by many nodes

    Important: a volume can only be mounted using one access mode at a time.

4. Class

    .spec.storageClassName specifies the name of a StorageClass

    (1) A PV of a particular class can only be bound to PVCs requesting that class
    
    (2) A PV with no **storageClassName** has no class and can only be bound to PVCs that request no particular class.

5. Reclaim Policy

    * Retain - manual reclamation

    * Recycle - basic scrub (rm -rf /thevolume/*)

    * Delete - associated storage asset such as AWS EBS, GCE PD, Azure Disk, or OpenStack Cinder volume is deleted

    Currently, only NFS and HostPath support recycling. AWS EBS, GCE PD, Azure Disk, and Cinder volumes support deletion.

6. Mount Options

    A Kubernetes administrator can specify additional mount options in .spec.mountOptions for when a Persistent Volume is mounted on a node.

    **Note**: Not all Persistent volume types support mount options.

    The following volume types support mount options:

    * GCEPersistentDisk
    * AWSElasticBlockStore
    * AzureFile
    * AzureDisk
    * NFS
    * iSCSI
    * RBD (Ceph Block Device)
    * CephFS
    * Cinder (OpenStack block storage)
    * Glusterfs
    * VsphereVolume
    * Quobyte Volumes

7. Phase

    A volume will be in one of the following phases:

    * Available – a free resource that is not yet bound to a claim
    * Bound – the volume is bound to a claim
    * Released – the claim has been deleted, but the resource is not yet reclaimed by the cluster
    * Failed – the volume has failed its automatic reclamation

## PersistentVolumeClaims

Each PVC contains a spec and status, which is the specification and status of the claim.

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 8Gi
  storageClassName: slow
  selector:
    matchLabels:
      release: "stable"
    matchExpressions:
      - {key: environment, operator: In, values: [dev]}
```

1. resources: request specific quantities of a resource

2. selector:

    Claims can specify a label selector to further filter the set of volumes. Only the volumes whose labels match the selector can be bound to the claim.

    * matchLabels - the volume must have a label with this value
    * matchExpressions - a list of requirements made by specifying key, list of values, and operator that relates the key and values. Valid operators include In, NotIn, Exists, and DoesNotExist.

    All of the requirements, from both **matchLabels** and **matchExpressions** are ANDed together – they must all be satisfied in order to match.

3. storageClassName: 
    
    * only PVs of the requested class, ones with the same **storageClassName** as the PVC, can be bound to the PVC
    * PVCs don't necessarily have to request a class. A PVC with its **storageClassName** set equal to "" is always be requesting a PV with no class(no annotation or one set equal to "". notes:annotation is the past).
    * A PVC with no **storageClassName** is not quite the same and is treated differently by the cluster depending on whether the DefaultStorageClass admission plugin is turned on.

        (1) if the admission plugin is turned on, the administrator may specify a default **StorageClass**. All PVCs without storageClassName can be bound only to PVs of that default.

        (2) If the admission plugin is turned off, there is no notion of a default StorageClass. All PVCs that have no storageClassName can be bound only to PVs that have no class. In this case, the PVCs that have no storageClassName are treated the same way as PVCs that have their storageClassName set to "".

    When a PVC specifies a selector in addition to requesting a StorageClass, the requirements are ANDed together: only a PV of the requested class and with the requested labels may be bound to the PVC.

    **Note**: Currently, a PVC with a non-empty **selector** can't have a PV dynamically provisioned for it.

## Claims As Volumes

Pods access storage by using the claim as a volume. Claims must exist in the same namespace as the pod using the claim. The cluster finds the claim in the pod’s namespace and uses it to get the **PersistentVolume** backing the claim. The volume is then mounted to the host and into the pod

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: dockerfile/nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```