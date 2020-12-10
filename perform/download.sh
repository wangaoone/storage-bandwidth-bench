#!/bin/bash

BASE=`pwd`/`dirname $0`
BASE=$BASE/../

SSHKEY="-x \"-i ~/.ssh/ops.pem\""

thread=(1 5 10 20 30)
EXECUTOR="parallel-ssh -i -h $BASE/perform/instance.log $SSHKEY"

PREFIX=
if [ "$1" != "s3" ] ; then
  PREFIX="$1-"
fi

echo "Downloading $1 log"
for i in "${thread[@]}"; do
  FILENAME=thread$i-$type-log
  /bin/bash -c "$EXECUTOR cat thread$i-${PREFIX}log >log/$1-thread$i.log"
done