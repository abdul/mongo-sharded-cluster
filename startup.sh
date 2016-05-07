#!/bin/sh
set -x
MONGO_LOG="/var/log/mongodb/mongod.log"
MONGO="/usr/bin/mongo"
MONGOD="/usr/bin/mongod"
MONGODBPATH="/var/lib/mongodb"
REPLSET="rs0"
$MONGOD --fork --replSet $REPLSET --noprealloc --smallfiles --logpath $MONGO_LOG
sleep 30
 
checkSlaveStatus(){
SLAVE=$1
$MONGO --host $SLAVE --eval db
while [ "$?" -ne 0 ]
do
echo "Waiting for slave to come up..."
sleep 15
$MONGO --host $SLAVE --eval db
done
}

 
if [ "$ROLE" == "master" ]
then
$MONGO --eval "rs.initiate()"
checkSlaveStatus $SLAVE1
$MONGO --eval "rs.add(\"${SLAVE1}:27017\")"
checkSlaveStatus $SLAVE2
$MONGO --eval "rs.add(\"${SLAVE2}:27017\")"
fi
tail -f /dev/null