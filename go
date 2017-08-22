#!/bin/bash -ex

VERSION=$1
BLD_NUM=$2
IMAGE=$3
if [ -z "$BLD_NUM" ]
then
  echo 'Usage: ./go VERSION BLD_NUM [IMAGE]'
  exit 1
fi
if [ -z "$IMAGE" ]
then
  IMAGE=couchbase/analytics-demo:${VERSION}-${BLD_NUM}
  echo "Using image name ${IMAGE}"
fi

docker build --build-arg CB_VERSION=${VERSION} --build-arg CB_BLD_NUM=${BLD_NUM} --tag ${IMAGE} .
