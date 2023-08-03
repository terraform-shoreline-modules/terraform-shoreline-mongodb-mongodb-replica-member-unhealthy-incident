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