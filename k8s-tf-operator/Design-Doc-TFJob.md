# the summary of Design Doc for TFJob

## Objective

The goal is to make it easy to run TensorFlow traiining on k8s. Using CRD.

## Background

CRD is cool to create a controller with the desired semantics for a particular workload while hiding users from the implementation.

## Design

### TFJob Resource

1. each TfReplica performs a role: master,parameter server or worker

2. **not to try to hide or replace K8s abstractions**,each TfReplica contains a standard K8s **PodTemplate** to specify the processes (including TF) to run in each replica. It's so nice. Furthermore, the PodTemplate makes it easy for TFJob users to leverage K8s features.