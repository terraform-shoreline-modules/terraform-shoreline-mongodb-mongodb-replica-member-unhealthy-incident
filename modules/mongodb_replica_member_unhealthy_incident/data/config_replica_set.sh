#!/bin/bash

# Set the replica set name, members list, and priority settings

REPLICA_SET_NAME=${REPLICA_SET_NAME}

REPLICA_SET_MEMBERS=${REPLICA_SET_MEMBERS}

REPLICA_SET_PRIORITIES=${REPLICA_SET_PRIORITIES}

# Verify the MongoDB configuration file for replica set configuration

if grep -Fxq "replSetName=$REPLICA_SET_NAME" /etc/mongod.conf

then

    echo "Replica set name is already set correctly"

else

    sed -i "s/#replication:/replication:\n  replSetName: $REPLICA_SET_NAME/" /etc/mongod.conf

    echo "Replica set name has been updated"

fi

if grep -Fxq "members:\n  - _id: 0\n    host: $REPLICA_SET_MEMBERS[0]\n    priority: $REPLICA_SET_PRIORITIES[0]" /etc/mongod.conf

then

    echo "Replica set members are already set correctly"

else

    sed -i "s/members:/members:\n  - _id: 0\n    host: $REPLICA_SET_MEMBERS[0]\n    priority: $REPLICA_SET_PRIORITIES[0]\n  - _id: 1\n    host: $REPLICA_SET_MEMBERS[1]\n    priority: $REPLICA_SET_PRIORITIES[1]\n  - _id: 2\n    host: $REPLICA_SET_MEMBERS[2]\n    priority: $REPLICA_SET_PRIORITIES[2]/" /etc/mongod.conf

    echo "Replica set members have been updated"

fi

# Restart MongoDB service to apply changes

systemctl restart mongod

echo "MongoDB service has been restarted"