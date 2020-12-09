#!/bin/bash

BASE=`pwd`/`dirname $0`
BASE=$BASE/../

SSHKEY="-x \"-i ~/.ssh/ops.pem\""

EXECUTOR="parallel-ssh -i -h $BASE/perform/instance.log $SSHKEY"

if [ "$1" == "s3" ] ; then
  echo "Downloading S3 log"
  /bin/bash -c "$EXECUTOR cat thred1-log >log/s3-thread1.log"
  /bin/bash -c "$EXECUTOR cat thred5-log >log/s3-thread5.log"
  /bin/bash -c "$EXECUTOR cat thred10-log >log/s3-thread10.log"
else
  echo "Downloading $1 log"
  /bin/bash -c "$EXECUTOR cat thread1-$1-log >log/$1-thread1.log"
  /bin/bash -c "$EXECUTOR cat thread5-$1-log >log/$1-thread5.log"
  /bin/bash -c "$EXECUTOR cat thread10-$1-log >log/$1-thread10.log"
fi