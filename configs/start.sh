#!/bin/bash
service rabbitmq-server start
rabbitmqctl add_vhost /sensu_docker; rabbitmqctl add_user sensu_docker sensu_docker;sudo rabbitmqctl set_permissions -p /sensu_docker sensu_docker ".*" ".*" ".*";
service redis-server start;service sensu-api restart;service sensu-server restart; 
# service uchiwa restart; 
# exec /usr/sbin/init