#!/bin/bash
thread=(10)
duration=20
type=$1
SSHKEY=

for i in "${thread[@]}"; do
  FILENAME=thread$i-$type-log
  echo "Current thread is $i"
  pssh -i -h instance.log ./storage-throughput-bench -storage $type -path "/fsx" -duration $duration -thread "$i" -o "$FILENAME"
  echo "Round $i finished"
done