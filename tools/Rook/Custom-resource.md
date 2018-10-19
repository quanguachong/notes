# Custom Resources

Rook allows you to create and manage your storage cluster through custom resource definitions (CRDs). Each type of resource has its own CRD defined.

* **Cluster**: A Rook cluster provides the basis of the storage platform to serve block, object stores, and shared file systems.

* **Pool**: A pool manages the backing store for a block store. Pools are also used internally by object and file stores.

* **Object Store**: An object store exposes storage with an S3-compatible interface.

* **File System**: A file system provides shared storage for multiple Kubernetes pods.

## Cluster

