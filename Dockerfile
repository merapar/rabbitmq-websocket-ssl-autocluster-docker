FROM rabbitmq:3.8.9-management-alpine
MAINTAINER Merapar

COPY rabbitmq-env.conf /etc/rabbitmq/rabbitmq-env.conf
COPY rabbitmq.config /etc/rabbitmq/rabbitmq.config

RUN chmod 777 /etc/rabbitmq/rabbitmq-env.conf &&\
    chmod 777 /etc/rabbitmq/rabbitmq.config

RUN rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management rabbitmq_web_stomp

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
