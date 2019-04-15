# Starting from base CentOS image
FROM centos:7

# Enabling SystemD
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# Enabling EPEL & Remi repo
RUN yum install -y epel-release
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
# Installing general tools/apps
RUN yum install -y vim wget telnet logrotate deltarpm sudo crontabs net-tools
RUN yum install -y nano git
RUN  wget https://repositories.sensuapp.org/yum/6/x86_64/sensu-1.7.0-2.el6.x86_64.rpm
RUN yum install  socat -y
RUN wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.1/rabbitmq-server-3.6.1-1.noarch.rpm
RUN rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
RUN yum install -y rabbitmq-server-3.6.1-1.noarch.rpm
RUN wget https://bintray.com/palourde/uchiwa/download_file?file_path=uchiwa-1.5.0-1.x86_64.rpm
RUN ls
RUN yum install -y download_file?file_path=uchiwa-1.5.0-1.x86_64.rpm
RUN yum install -y sensu-1.7.0-2.el6.x86_64.rpm
RUN yum install -y redis
RUN sensu-install -P process-checks,network-checks,disk-checks,cpu-checks,memory-checks
COPY configs/container/default/etc/sensu /etc/sensu/
COPY configs/start.sh  /start.sh
RUN chmod +x /start.sh
RUN systemctl enable redis
RUN systemctl enable rabbitmq-server
RUN systemctl enable sensu-client 
RUN systemctl enable sensu-api
RUN systemctl enable sensu-server
RUN systemctl enable uchiwa
#3000 uchiwa RabbitMQ 5672 sensu-api 4567 redis 6379
EXPOSE 3000 4567 5672 15672 6379
# ENTRYPOINT ["/start.sh"]
CMD ["/usr/sbin/init"]
