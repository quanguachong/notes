# AMQP 0-9-1 Model

AMQP 0-9-1 protocol is one of the protocols supported by RabitMQ.

1. Concepts:

* [Exchange](#Exchange)
* [Queues](#Queues)
-----------------------------------------
2. Codes:

* [Connection](#connection)
* [Channel](#channel)


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

## connection

```go
type Connection struct {
    Config Config // The negotiated Config after connection.open

    Major      int      // Server's major version
    Minor      int      // Server's minor version
    Properties Table    // Server properties
    Locales    []string // Server locales
    // contains filtered or unexported fields
}
```

Connection manages the serialization and deserialization of frames from IO and dispatches the frames to the appropriate channel. All RPC methods and asynchronous Publishing, Delivery, Ack, Nack and Return messages are multiplexed on this channel. There must always be active receivers for every asynchronous message on this connection.

-------------------------------

func **Dial**
```go
func Dial(url string) (*Connection, error)
```

Dial accepts a string in the AMQP URI format and return a new Connection over TCP using PlainAuth.

Defaults to a server heartbeat interval of 10 seconds and sets the handshake deadline to 30 seconds. After handshake, deadlines are cleared.

Dial uses the zero value of tls.Config when it encounters an amqp:// scheme.

-------------------------------

func **Channel**
```go
func (c *Connection) Channel() (*Channel, error)
```

Channel opens a unique, concurrent server channel to process the bulk of AMQP messages.

**Any error from methods on this receiver will render the receiver invalid and a new Channel should be opened**. 

--------------------------------

func **Close**
```go
func (c *Connection) Close() error
```

Close requests and waits for the response to close the AMQP connection. 

It's advisable to use this message when publishing to ensure all kernel buffers have been flushed on the server and client before exiting.

An error indicates that server may not have received this request to close but the connection should be treated as closed regardless. 

After returning from this call, all resources associated with this connection, including the underlying io, Channels, Notify listeners and Channel consumers will also be closed.

## channel

```go
type Channel struct {
    // contains filtered or unexported fields
}
```

Channel represents an AMQP channel. Used as a context for valid message exchange.

Errors on methods with this Channel as a receiver means this channel should be discarded and a new channel established.
