#!/bin/sh
set -x

MONGO_LOG="/var/log/mongodb/mongod.log"
MONGO="/usr/bin/mongo"
MONGOS="/usr/bin/mongos"
PORT=27017
CONFIG_PORT=27019
COUNTER=1

checkConfigStatusAndSetupMongos(){
  CONFIG_SERVER=$1
  while [ 1 ]
  do
    echo "Waiting for CONFIG SERVER ${CONFIG_SERVER} to come up..."
    sleep 5
    CONFIG_MEMBERS=`$MONGO --host $CONFIG_SERVER --port $CONFIG_PORT --quiet --eval "rs.status().members.length"`
    CONFIG_MEMBERS_EXPECTED="3"
    if [ "$CONFIG_MEMBERS" = "$CONFIG_MEMBERS_EXPECTED" ]
      then
      $MONGOS --fork --configdb configReplSet/${CONFIG_PREFIX}0,${CONFIG_PREFIX}1,${CONFIG_PREFIX}2 --logpath $MONGO_LOG
      return 0
    fi
  done  
  echo "MONGOS STARTED WITH:  --configdb configReplSet/${CONFIG_PREFIX}0,${CONFIG_PREFIX}1,${CONFIG_PREFIX}2"
}

checkAndAddReplicasToShard(){
  REPLICA_SERVER=$1
  while [ 1 ]
  do
    echo "Waiting for REPLICA SERVER ${REPLICA_SERVER} to come up..."
    sleep 5
    MEMBERS=`$MONGO --host $REPLICA_SERVER --port $PORT --quiet --eval "rs.status().members.length"`
    EXPECTED="${NODES_PER_REPLICAS}"
    if [ "$MEMBERS" = "$EXPECTED" ] 
      then
      $MONGO --eval "printjson(sh.addShard(\"${REPLSET_PREFIX}${COUNTER}/${REPLICA_SERVER}\"))"
      return 0
    fi
  done
}

checkConfigStatusAndSetupMongos $CONFIG_REPLICA_PRIMARY

while [  $COUNTER -le $DATA_REPLICA_COUNT ]; do
  checkAndAddReplicasToShard "${REPLICA_SUFFIX}${COUNTER}_0"
  let COUNTER=COUNTER+1 
done
echo "MongoDB Sharded Cluster should be ready."
echo "Please check Sharding status with sh.status() by connecting to mongos instance."
tail -f /dev/null