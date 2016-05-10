#!/bin/sh
set -x
MONGO_LOG="/var/log/mongodb/mongod.log"
MONGO="/usr/bin/mongo"
MONGOD="/usr/bin/mongod"
MONGODBPATH="/var/lib/mongodb"
REPLSET="configReplSet"
CONFIG_PORT=27019
$MONGOD --fork --configsvr --replSet $REPLSET --dbpath=$MONGODBPATH --logpath $MONGO_LOG
sleep 10

checkReplicaStatus(){
  REPLICA_SERVER=$1
  $MONGO --host ${REPLICA_SERVER} --port $CONFIG_PORT --eval db
  while [ "$?" -ne 0 ]
  do
    echo "Waiting for Replica ${REPLICA_SERVER} to come up..."
    sleep 5
    $MONGO --host ${REPLICA_SERVER} --port $CONFIG_PORT --eval db
  done
}


if [ "$ROLE" == "PRIMARY" ]
  then
  $MONGO --port $CONFIG_PORT --eval "rs.initiate()"
  COUNTER=1
  while [  $COUNTER -lt $REPLICA_NODE_COUNT ]; do
    checkReplicaStatus $REPLICA_NODE_PREFIX$COUNTER
    $MONGO --port $CONFIG_PORT --eval "rs.add(\"${REPLICA_NODE_PREFIX}${COUNTER}:${CONFIG_PORT}\")"
    let COUNTER=COUNTER+1 
  done
  echo "Replica $(REPLSET) should be ready."
  echo "Please check Replica status with rs.status() by connecting to ${REPLICA_NODE_PREFIX}_0"
fi
tail -f /dev/null