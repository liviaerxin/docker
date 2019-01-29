#!/bin/bash
set -eo pipefail

export SERVER_ID=1

if [[ -n $REPLICATION_MODE ]]; then
  # master-slave replication mode
  case $REPLICATION_MODE in
    master)
      cp -v /opt/init-master.sh /docker-entrypoint-initdb.d/
      cp -v /opt/*.sql /docker-entrypoint-initdb.d/
      cp -v /opt/repl-master.cnf /etc/mysql/conf.d/
      ;;
    slave)
      SERVER_ID=$(((RANDOM%1000)+1))
      cp -v /opt/init-slave.sh /docker-entrypoint-initdb.d/
      cp -v /opt/repl-slave.cnf /etc/mysql/conf.d/
      ;;
    *)
      echo "UNKNOWN REPLICATION_MODE: ${REPLICATION_MODE}"
      exit 1
  esac
else
  # single mode
  cp -v /opt/*.sql /docker-entrypoint-initdb.d/
fi

cp -v /opt/init.sh /docker-entrypoint-initdb.d/

cat > /etc/mysql/conf.d/server.cnf << EOF
[mysqld]
innodb_buffer_pool_size=2G # can be set up tp 60-70% of the RAM
innodb_log_file_size=512M
query_cache_size=128M
tmp_table_size=128M # 64M for every GB of RAM
max_heap_table_size=128M # shoul have the same size with 'tmp_table_size'
slow_query_log=1 # enable to log slow queries for debug and analyze them
slow_query_log-file=/var/lib/mysql/mysql-slow.log
long_query_time=2 # seconds
max_connections=150
connect_timeout=10 # seconds
wait_timeout=28800
interactive_timeout=28800
server_id=$SERVER_ID
log_error=/var/log/mysql.err
default_time_zone='+00:00'
EOF

exec docker-entrypoint.sh "$@"
