#!/bin/bash
thread=(1)
duration=30

for i in "${thread[@]}"; do
  FILENAME=$i-log
  echo "Current thread is $i"
  pssh -i -h instance.log ./storage-throughput-bench -duration $duration -thread "$i" -o "$FILENAME"
  echo "Round $i finished"
done