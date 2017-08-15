#!/bin/sh
sed -i -e "s/{{CUSTOM_DEFAULT_USER}}/$CUSTOM_DEFAULT_USER/g" /etc/rabbitmq/rabbitmq.config
sed -i -e "s/{{CUSTOM_DEFAULT_PASSWORD}}/$CUSTOM_DEFAULT_PASSWORD/g" /etc/rabbitmq/rabbitmq.config

chmod 777 /rabbitmq_mnesia

docker-entrypoint.sh rabbitmq-server &
rabbitMQ=$!
echo 'Sleeping, awaiting for RabbitMQ to have completely started'
sleep 15
echo 'Done sleeping, continiung clustering'

if [ "$MY_POD_NAME" == 'rabbitmq-0' ]
then
  rabbitmqctl set_policy HA '.*' '{"ha-mode": "all"}'
else
  rabbitmqctl stop_app
  rabbitmqctl join_cluster rabbit@rabbitmq-0.rabbitmq
  rabbitmqctl start_app
fi

wait $rabbitMQ
