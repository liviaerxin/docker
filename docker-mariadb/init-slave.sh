#!/bin/bash
# TODO: cover slave side selection for replication entities:
# * replicate-do-db=db_name only if we want to store and replicate certain DBs
# * replicate-ignore-db=db_name used when we don't want to replicate certain DBs
# * replicate_wild_do_table used to replicate tables based on wildcard patterns
# * replicate_wild_ignore_table used to ignore tables in replication based on wildcard patterns 

REPLICATION_HEALTH_GRACE_PERIOD=${REPLICATION_HEALTH_GRACE_PERIOD:-3}
REPLICATION_HEALTH_TIMEOUT=${REPLICATION_HEALTH_TIMEOUT:-30}
MYSQLDUMP_HOST=${MYSQLDUMP_HOST:-$MASTER_HOST}
MYSQLDUMP_PORT=${MYSQLDUMP_PORT:-$MASTER_PORT}

check_slave_health () {
  echo Checking replication health:
  status=$(mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW SLAVE STATUS\G")
  echo "$status" | egrep 'Slave_(IO|SQL)_Running:|Seconds_Behind_Master:|Last_.*_Error:' | grep -v "Error: $"
  if ! echo "$status" | grep -qs "Slave_IO_Running: Yes"    ||  
     ! echo "$status" | grep -qs "Slave_SQL_Running: Yes"   ||
     ! echo "$status" | grep -qs "Seconds_Behind_Master: 0" ; then
    echo WARNING: Replication is not healthy.
    return 1
  fi
  echo Replication is healthy.
  return 0
}

# wait-for-it $MASTER_HOST $MASTER_PORT
echo Waiting for master up...
until mysql -h $MASTER_HOST -P $MASTER_PORT -u $REPLICATION_USER -p$REPLICATION_PASSWORD -eexit; do
  echo Master is unvaiblable -- sleeping...
  sleep 3
done
echo Master is up.

echo Updating master connetion info in slave.

mysql -u root -p$MYSQL_ROOT_PASSWORD -e "
 SET GLOBAL slow_query_log = 'OFF';"

mysql -u root -p$MYSQL_ROOT_PASSWORD -e "
  CHANGE MASTER TO \
  MASTER_HOST='$MASTER_HOST', \
  MASTER_PORT=$MASTER_PORT, \
  MASTER_USER='$REPLICATION_USER', \
  MASTER_PASSWORD='$REPLICATION_PASSWORD';"

mysqldump \
  --protocol=tcp \
  --user=$REPLICATION_USER \
  --password=$REPLICATION_PASSWORD \
  --host=$MYSQLDUMP_HOST \
  --port=$MYSQLDUMP_PORT \
  --hex-blob \
  --all-databases \
  --add-drop-database \
  --master-data \
  --flush-logs \
  --flush-privileges \
  | mysql -u root -p$MYSQL_ROOT_PASSWORD

echo mysqldump completed.

echo Starting slave ...
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "START SLAVE;"

echo Waiting for health grace period and slave to be still healthy:
sleep $REPLICATION_HEALTH_GRACE_PERIOD

counter=0
while ! check_slave_health; do
  echo counter
  if (( counter >= $REPLICATION_HEALTH_TIMEOUT )); then
    echo ERROR: Replication not healthy, health timeout reached, failing.
    exit 1
  fi
  let counter=counter+1
  sleep 1
done