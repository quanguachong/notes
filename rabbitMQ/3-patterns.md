# There are several patterns in rabbitMQ

* [publish/subscribe](#publish/subscribe)

* [Topics](#topics)

## publish/subscribe

Broadcast messages to many consumers at once.

Use producer, exchange, binding, queue, consumer

emit_log_PS.go: ExchangeDeclare, Publish

receive_logs_PS.go: ExchangeDeclare, QueueDeclare, QueueBind, Consume

Concrete codes:
* [emit_log_PS.go](./examples-codes/emit_log_PS.go)
* [receive_logs_PS.go](./examples-codes/receive_logs_PS.go)

## Routing

Receiving messages selectively.

Use exchange whose type is *direct*.

Illustrate that with followings

1. one binding to one queue

[routing-1](./image/routing-1)

we can see the **direct** exchange **X** with two queues bound to it. The first queue is bound with binding key **orange**, and the second has two bindings, one with binding key **black** and the other one with **green**.

In such a setup a message published to the exchange with a routing key **orange** will be routed to queue Q1. Messages with a routing key of **black** or **green** will go to Q2. All other messages will be discarded

2. one binding to multiple queues

[routing-2](./image/routing-2)



## Topics

Receiving messages based on a pattern(topics)