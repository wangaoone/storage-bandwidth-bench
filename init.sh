#!/bin/bash

echo "#!bin/bash" > ./env.sh
echo "export LAMBDAPREFIX=\"ElasticMB$1-\"" >> ./env.sh
