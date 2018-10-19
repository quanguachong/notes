# kafka library for golang call sarama

`import "github.com/Shopify/sarama"`

Package sarama is a pure Go client library for dealing with Apache Kafka (versions 0.8 and later).

It includes a high-level API for easily producing and consuming messages, and a low-level API for controlling bytes on the wire when the high-level API is insufficient.

## Produce messages

Use either the **AsyncProducer** or the **SyncProducer**.

1. AsyncProducer: accepts messages on a channel and produces them asynchronously in the background as efficiently as possible
    
    It is preferred in most cases.

2. SyncProducer: The SyncProducer provides a method which will block until Kafka acknowledges the message as produced.

    Two caveats:
    * It will generally be less efficient
    * The ack depends on the value of `Producer.RequiredAcks` which can be lost

## Consume messages

Use the **Consumer**.

