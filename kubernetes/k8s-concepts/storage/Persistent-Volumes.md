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

2. 