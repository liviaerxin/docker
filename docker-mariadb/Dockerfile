FROM mariadb:10.1

RUN apt-get update && \
	apt-get install -y \
		inetutils-ping \
		locales \
		supervisor \
		vim \
	&& rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoclean && apt-get autoremove

COPY locale.gen /etc/
RUN locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

COPY filebeat-5.5.2-amd64.deb /tmp/
RUN dpkg -i /tmp/filebeat-5.5.2-amd64.deb ; rm /tmp/filebeat-5.5.2-amd64.deb

COPY filebeat.yml /etc/filebeat/filebeat.yml
RUN chmod 644 /etc/filebeat/filebeat.yml

COPY supervisord.conf /etc/supervisor/
COPY supervisor.conf.d/* /etc/supervisor/conf.d/

# define the database `DPMS`
ENV MYSQL_DATABASE DPMS
ENV MASTER_PORT 3306
ENV REPLICATION_USER repl_user
ENV REPLICATION_PASSWORD repl_password

COPY init.sh /opt/
COPY init-master.sh /opt/
COPY repl-master.cnf /opt/	
COPY init-slave.sh /opt/
COPY repl-slave.cnf /opt/
COPY initdb.d/*.sql /opt/

COPY replication-entrypoint.sh /opt/
RUN chmod +x /opt/replication-entrypoint.sh

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
