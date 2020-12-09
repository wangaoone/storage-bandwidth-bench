#!/bin/bash

BASE=`pwd`/`dirname $0`
BASE=$BASE/../

thread=(1 5 10)
duration=20
type=$1
SSHKEY="-x \"-i ~/.ssh/ops.pem\""

EXECUTOR="pssh -i -h instance.log $SSHKEY ."

if [ "$2" == "local" ] ; then
  EXECUTOR="$BASE"
fi

for i in "${thread[@]}"; do
  FILENAME=thread$i-$type-log
  echo "Current thread is $i"
  /bin/bash -c "$EXECUTOR/storage-bandwidth-bench -storage $type -duration $duration -thread \"$i\" -o \"$FILENAME\""
  echo "Round $i finished"
done