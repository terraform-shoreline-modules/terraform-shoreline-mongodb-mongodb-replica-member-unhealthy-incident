
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB replica member unhealthy incident.
---

This incident type refers to an issue with a MongoDB replica set, where one or more members of the set have been marked as unhealthy. This can happen due to various causes, such as network issues, hardware failures, or configuration problems. When this occurs, it can impact the availability and performance of the database system, which can lead to data loss or corruption. Prompt resolution of this incident is necessary to prevent further damage and restore the normal functioning of the replica set.

### Parameters
```shell
# Environment Variables

export REPLICA_SET_NAME="PLACEHOLDER"

export MEMBER_HOSTNAME="PLACEHOLDER"

export PATH_TO_CONFIG_FILE="PLACEHOLDER"

export REPLICA_SET_PRIORITIES="PLACEHOLDER"

export REPLICA_SET_MEMBERS="PLACEHOLDER"
```

## Debug

### Check if MongoDB is running
```shell
systemctl status mongod
```

### Check the replica set status
```shell
mongo --eval "rs.status()"
```

### Check the replica set configuration
```shell
mongo --eval "rs.conf()"
```

### Check the replica set members
```shell
mongo --eval "rs.isMaster()"
```

### Get the MongoDB log file
```shell
tail -f /var/log/mongodb/mongod.log
```

### Check the disk usage
```shell
df -h
```

### Check the memory usage
```shell
free -h
```

### Check the MongoDB process ID
```shell
pgrep mongod
```

### Check the CPU usage
```shell
top
```

### Check the MongoDB replica set members status
```shell
mongo --eval "rs.status().members"
```

### Check the MongoDB replica set members health
```shell
mongo --eval "rs.status().members.forEach(function(member) { print(member.name + ' is ' + member.stateStr); })"
```

### Check the MongoDB replica set members state
```shell
mongo --eval "rs.status().members.forEach(function(member) { print(member.name + ' is ' + member.stateStr); })"
```

### Check the MongoDB version
```shell
mongo --eval "db.version()"
```

### Check the MongoDB storage engine
```shell
mongo --eval "db.serverStatus().storageEngine"
```

### Check the MongoDB memory usage
```shell
mongo --eval "db.serverStatus().mem"
```

### Check the MongoDB network usage
```shell
mongo --eval "db.serverStatus().network"
```

### Check the MongoDB oplog size
```shell
mongo --eval "db.getReplicationInfo().logSizeMB"
```

### Check the MongoDB oplog window
```shell
mongo --eval "db.getReplicationInfo().timeDiff"
```

### Check the MongoDB oplog length
```shell
mongo --eval "db.getReplicationInfo().oplogLength"
```

### Check the MongoDB oplog utilization
```shell
mongo --eval "db.getReplicationInfo().usedMB"
```

### Check the MongoDB oplog capacity
```shell
mongo --eval "db.getReplicationInfo().totalMB"
```

### Check the MongoDB oplog status
```shell
mongo --eval "db.printReplicationInfo()"
```

### Check the MongoDB oplog sync status
```shell
mongo --eval "rs.printSlaveReplicationInfo()"
```

### Check the MongoDB oplog lag time
```shell
mongo --eval "rs.printSlaveReplicationInfo().syncMillis"
```

### Check the MongoDB oplog sync source
```shell
mongo --eval "rs.printSlaveReplicationInfo().source"
```

### Check the MongoDB oplog sync state
```shell
mongo --eval "rs.printSlaveReplicationInfo().state"
```
## Repair

### Define the IP addresses of the MongoDB replica members
```shell
PRIMARY="PLACEHOLDER"

SECONDARY="PLACEHOLDER"

ARBITER="PLACEHOLDER"
```

### Check the network connectivity between MongoDB replica members
```shell
if ping -c 3 $PRIMARY && ping -c 3 $SECONDARY && ping -c 3 $ARBITER; then

    echo "Network connectivity between MongoDB replica members is OK"

else

    echo "Network connectivity between MongoDB replica members is not OK"

    # Restart network service to resolve the issue

    service network restart

    echo "Network service restarted"

fi
```

### Verify the MongoDB configuration file for replica set configuration and ensure that it has correct replica set name, members list, and priority settings.
```shell
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

```
### Restart the MongoDB replica set members one by one to ensure that the latest data is replicated to all members and the issue is resolved.
```shell
#!/bin/bash

# Define the replica set members

MEMBER1="PLACEHOLDER"
 
MEMBER2="PLACEHOLDER"

MEMBER3="PLACEHOLDER"

replica_set_members=(${MEMBER1} ${MEMBER2} ${MEMBER3})

# Loop through each replica set member and restart them

for member in "${replica_set_members[@]}"

do

    echo "Restarting MongoDB replica set member: $member"

    ssh $member "sudo systemctl restart mongodb"

done

echo "MongoDB replica set members have been restarted."

```