#!/bin/bash

BASE=`pwd`/`dirname $0`
BASE=$BASE/../

SSHKEY="-x \"-i ~/.ssh/ops.pem\""

parallel-ssh -i -h $BASE/perform/instance.log $SSHKEY rm ./thread*