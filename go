#!/bin/bash -ex

if [ ! -e couchbase-analytics-*.zip ]
then
    echo "No local build - aborting!"
    exit 5
fi

mkdir -p build
if [ couchbase-analytics-*.zip -nt build/cbas ]
then
  (
    cd build
    unzip ../couchbase-analytics-*.zip
    sed -i -e 's/=data/=\/opt\/couchbase\/var\/analytics\/data/g' \
      cbas/opt/local/conf/*.conf
    sed -i -e 's/^LOGSDIR=.*$/LOGSDIR=\/opt\/couchbase\/var\/analytics\/logs/' \
      cbas/opt/local/bin/start-sample-cluster.sh
  )
fi

IMAGE=${1-couchbase/analytics-demo}

docker build --tag ${IMAGE} .
