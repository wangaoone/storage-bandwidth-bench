#!/bin/bash

echo "#!bin/bash" > ./env.sh
echo "export LAMBDAPREFIX=\"ElasticPublic$1-\"" >> ./env.sh
echo "export PUBLICIP=\"$2\"" >> ./env.sh
