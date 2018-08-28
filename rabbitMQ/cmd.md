# common cmd for rabbitMQ

```bash
rabbitmq-server  # start rabbitMQ server

sudo rabbitmqctl list_exchanges # list the exchanges on the server

rabbitmactl list_bindings # list the bindings on the server

rabbitmqadmin -q delete queue name=<insert-name> # delete queue whose name is <insert-name>

# delete all queues
rabbitmqadmin -f tsv -q list queues name > q.txt 
while read -r name; do rabbitmqadmin -q delete queue name="${name}"; done <q.txt


```
