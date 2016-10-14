#!/bin/bash -e

if [ ! -e build ]
then
  mkdir build
fi
if [ couchbase-analytics-*.zip -nt build/cbas ]
then
  (
    cd build
    unzip ../couchbase-analytics-*.zip
    sed -i -e 's/=data/=\/opt\/couchbase\/var\/analytics\/data/g' \
      cbas/samples/local/conf/*.conf
    sed -i -e 's/^LOGSDIR=.*$/LOGSDIR=\/opt\/couchbase\/var\/analytics\/logs/' \
      cbas/samples/local/bin/start-sample-cluster.sh
  )
fi

docker build --tag couchbaselabs/analytics-demo .

