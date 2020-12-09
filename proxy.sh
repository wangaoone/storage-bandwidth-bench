#!/bin/bash

source ./env.sh
echo $LAMBDAPREFIX

cd /home/ubuntu/go/src/github.com/mason-leap-lab/infinicache/evaluation

if [ "$1" == "start" ] ; then
  make start-server
elif [ "$1" == "stop" ] ; then
  make stop-server
fi
