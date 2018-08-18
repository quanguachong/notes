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

## (TODO: czx)