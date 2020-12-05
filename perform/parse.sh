#!/bin/bash

pssh -i -h instance.log tail -1 thread1-redis-log
pssh -i -h instance.log tail -1 thread5-redis-log
pssh -i -h instance.log tail -1 thread10-redis-log
