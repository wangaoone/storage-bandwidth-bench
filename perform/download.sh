#!/bin/bash

echo "Downloading S3 log"
pssh -i -h instance.log cat thred1-log >log/s3-thread1.log
pssh -i -h instance.log cat thred5-log >log/s3-thread5.log
pssh -i -h instance.log cat thred10-log >log/s3-thread10.log

echo "Downloading Redis log"
pssh -i -h instance.log cat thread1-redis-log >log/redis-thread1.log
pssh -i -h instance.log cat thread5-redis-log >log/redis-thread5.log
pssh -i -h instance.log cat thread10-redis-log >log/redis-thread10.log
