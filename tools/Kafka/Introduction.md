# Introduction of Kafka

Apache Kafka is a distributed streaming platform.

## Concepts

* Kafka is run as a cluster on one or more servers that can span multiple datacenters. 

* The Kafka cluster stores streams of **records** in categories called **topics**.

* Each record consists of **a key, a value, and a timestamp**.

## Architecture

Blocks of Kafka: Producers, Consumers, Processors, Connectors, Topics, Partitions and Brokers.

![architecture](./image/architecture.png)

---
---

Brokers, Topics and their Partitions's relations:

In the following diagram, there are three topics:

Topic 0 has two partitions(partition 0,1) with 3 replications

Topic 1 and 2 both have one partition(partition 0) with 2 replications

![relations](./image/brokers-topics-partitions.png)