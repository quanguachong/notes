# Disruptions

This guide is for application owners who want to build highly available applications, and thus need to understand what types of Disruptions can happen to Pods.

It is also for Cluster Administrators who want to perform automated cluster actions, like upgrading and autoscaling clusters.

## Voluntary and Involuntary Disruptions

Pods disappear after someone destroys them, or there is an unavoidable hardware or system software error.

We call these unavoidable cases **involuntary disruptions** to an application.

Except for the out-of-resources condition, other cases are **voluntary disruptions**.

## Disruption Budget

An application owner can create a PodDisruptionBudget(PDB) object for each application. A PDB limits the numeber pods of a replicated application that down simultaneously from **voluntary disruptions**.

## [PDB Example](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)

## Specifying a PodDisruptionBudget

A PodDisruptionBudget has three fields:

* .spec.selector (required, label selector)
* .spec.minAvailable (either a number or a percentage)
* .spec.maxUnabailable (either a number or a percentage)

You can specify only one of **maxUnavailable** and **minAvailable** in a single **PodDisruptionBudget**

**Note:** A disruption budget does not truly guarantee that the specified number/percentage of pods will always be up.

Example PDB Using minAvailable(the following matches pods ):

```yaml
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: zk-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: zookeeper
```