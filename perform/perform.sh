#!/bin/bash
thread=(1 5 10)
duration=20
type=$1
SSHKEY=~/.ssh/tianium

for i in "${thread[@]}"; do
  FILENAME=thread$i-$type-log
  echo "Current thread is $i"
  pssh -i $SSHKEY -h instance.log ./storage-bandwidth-bench -storage $type -endpoint bandwidth-test.lqm2mp.0001.use1.cache.amazonaws.com:6379 -duration $duration -thread "$i" -o "$FILENAME"
  echo "Round $i finished"
done