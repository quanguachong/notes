# Volumes

On-dish files in a Container are ephemeral, which presents some problems for non-trivial applications when running in Containers. The Kubernetes Volume abstraction solves both of these problems.

1. kubelet restarts crashed containers with a clean state, the files will be lost

2. it's often necessary to share files between containers in a Pod

# Background

Docker has a concept of volumes, which less managed, a volume is simply a directory on disk or in another Container.Docker provides volume drivers, but limited.

A Kubernetes volume:
1. a volume has an explicit lifetime--the same as the pod that encloses it. The volume can maintain data for pod.

2. a volume is just a directory, which is accessible to the Containers in a Pod. How that directory comes to be, the medium that backs it, and the contents of it are determined by the particular volume type used.

3. To use a volume, a Pod specifies what volumes in .spec.volumes field, where to mount in containers in .spec.containers.volumeMounts field

4. A process in a container sees a filesystem view composed from their Docker image and volumes. The Docker image is at the root of the filesystem hierarchy, and **any volumes are mounted at the specified paths within the image**. Volumes can not mount onto other volumes or have hard links to other volumes. Each Container in the Pod must independently specify where to mount each volume.

# Types of Volumes

Kubernetes supports several types of Volumes:

* awsElasticBlockStore
* azureDisk
...

# Using subPath

Sometimes, it's useful to share one volume for multiple uses in a single Pod. The field **volumeMounts.subPath** can be used to specify a sub-path inside the referenced volume instead of its root.

Example1: the following is a Pod using a single, shared volume.

1. the mountPath /var/lib/mysql of the container mysql will be bound to mysql(specified by subPath) of volume site-data

2. the mountPath /var/www/html of the container php will be bound to html(specified by subPath) of volume site-data

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-lamp-site
spec:
    containers:
    - name: mysql
      image: mysql
      env:
      - name: MYSQL_ROOT_PASSWORD
        value: "rootpasswd" 
      volumeMounts:
      - mountPath: /var/lib/mysql
        name: site-data
        subPath: mysql
    - name: php
      image: php:7.0-apache
      volumeMounts:
      - mountPath: /var/www/html
        name: site-data
        subPath: html
    volumes:
    - name: site-data
      persistentVolumeClaim:
        claimName: my-lamp-site-data
```

Example2: using subPath with expanded environment variables

**subPath** directory names can also be constructed from Downward API environment variables. Before you use this feature, you must enable the **VolumeSubpathEnvExpansionfeature** gate.

In this example, a Pod uses **subPath** to create a directory **pod1** within the hostPath volume /var/log/pods, using the pod name from the Downward API. The host directory /var/log/pods/pod1 is mounted at /logs in the container.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod1
spec:
  containers:
  - name: container1
    env:
    - name: POD_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.name
    image: busybox
    command: [ "sh", "-c", "while [ true ]; do echo 'Hello'; sleep 10; done | tee -a /logs/hello.txt" ]
    volumeMounts:
    - name: workdir1
      mountPath: /logs
      subPath: $(POD_NAME)
  restartPolicy: Never
  volumes:
  - name: workdir1
    hostPath: 
      path: /var/log/pods
```

# Resources

The storage media (Disk, SSD, etc.) of an emptyDir volume is determined by the medium of the filesystem holding the kubelet root dir (typically /var/lib/kubelet). There is no limit on how much space an emptyDir or hostPath volume can consume, and no isolation between Containers or between Pods.