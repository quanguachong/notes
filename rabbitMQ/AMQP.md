# AMQP 0-9-1 Model

AMQP 0-9-1 protocol is one of the protocols supported by RabitMQ.

* [Exchange](#Exchange)
* [Queues](#Queues)

## Overview

AMQP 0-9-1 (Advanced Message Queuing Protocol) is a messaging protocol that enables conforming client applications to communicate with conforming messaging middleware brokers.

## Exchange

Exchanges are AMQP entities where messages are sent. Exchanges take a message and route it into zero or more queues. The routing algorithm used depends on the exchange type and rules called bindings. AMQP 0-9-1 brokers provide four exchange types:

|Name               | Default pre-declared names            |
|-------------------|---------------------------------------|
|Direct exchange    | (Empty string) and amq.direct         |
|Fanout exchange    | amq.fanout                            |
|Topic exchange     | amq.topic                             |
|Headers exchange   | amq.match(and amq.headers in RabbitMQ)|

Besides the exchange type, exchanges have some important attributes:
* Name
* Durability(exchanges survive broker restart)
* Auto-delete (exchange is deleted when last queue is unbound from it)
* Arguments (optional, used by plugins and broker-specific features)

e.g.
```go
err = ch.ExchangeDeclare(
	"logs",   // name
	"fanout", // type
	true,     // durable
	false,    // auto-deleted
	false,    // internal
	false,    // no-wait
	nil,      // arguments
)
```

### Default Exchange

One situation of direct Exchange. The default exchange is a direct exchange with no name pre-declared by the broker.

Every queue created is automatically bound to the default exchange with a routing-key which is the same as the queue name. In other words, the default exchange is not declared explicitly.

### Direct Exchange

A direct exchange delivers messages to queues based on the message routing key.

[details in routing](./3-patterns.md#routing)

### Fanout Exchange

A fanout exchange routes messages to all of the queues that are bound to it and the routing key is ignored.

[details in publish/subscribe](./3-patterns.md#publish/subscribe)

### Topic Exchange

Topic exchanges route messages to one or many queues based on matching between a message routing key and the pattern that was used to bind a queue to an exchange.

[details in topics](./3-patterns.md#topics)

### Headers Exchange

Headers exchanges route based on header values. A message is considered matching if the value of the header equals the value specified upon binding.

Can specify Publishing.Header and queueBind.Arguments to complete the headers exchanges. Both's types are map[string]interface{}

A special argument named "x-match", which can be added in bindings and publish. It's value can be "any" or "all", "all" is the default value. Differences:

* "all" means all header pairs(key, value) must match.
* "any" means at least one of the header pairs must match.

```go
err = ch.Publish(
		"",     // exchange
		q.Name, // routing key
		false,  // mandatory
		false,  // immediate
		amqp.Publishing{
			// can specify Publishing.Header to complete header exchange
			ContentType: "text/plain",
			Body:        []byte(body),
		})
```

```go
err = ch.QueueBind(
		q.Name, // queue name
		"",     // routing key
		"logs", // exchange
		false,
		// this is queueBind.Arguments
		nil)
```

example:



## Queues

some properties:
* Name
* Durable (the queue will survive a broker restart)
* Exclusive (used by only one connection and the queue will be deleted when that connection closes)
* Auto-delete (queue that has had at least one consumer is deleted when last consumer unsubscribes)
* Arguments (optional; used by plugins and broker-specific features such as message TTL, queue length limit, etc)

**Durability** about the queue and message: Durability of a queue does not make messages that are routed to that queue durable. If broker is taken down and then brought back up, durable queue will be re-declared during broker startup, however, only persistent messages will be recovered.

```go
q, err := ch.QueueDeclare(
		"",    // name
		false, // durable
		false, // delete when unused
		true,  // exclusive
		false, // no-wait
		nil,   // arguments
	)
```

