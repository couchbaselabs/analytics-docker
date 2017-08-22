#!/bin/sh

echo "Configuring Couchbase Server.  Please wait (~60 sec)..."
sleep 15
export PATH=/opt/couchbase/bin:${PATH}

# Setup index and memory quota
curl -sS http://127.0.0.1:8091/pools/default -d memoryQuota=300 -d indexMemoryQuota=500 -d cbasMemoryQuota=1024 > /dev/null

# Setup services
echo "Configuring Services..."
curl -sS http://127.0.0.1:8091/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex%2Ccbas > /dev/null

# Setup credentials
curl -sS http://127.0.0.1:8091/settings/web -d port=8091 -d username=Administrator -d password=password > /dev/null

# Setup Memory Optimized Indexes
curl -sS -i -u Administrator:password -X POST http://127.0.0.1:8091/settings/indexes -d 'storageMode=memory_optimized' > /dev/null

# Load beer-sample bucket
curl -sS -u Administrator:password -X POST http://127.0.0.1:8091/sampleBuckets/install -d '["beer-sample"]'

# Load travel-sample bucket
curl -sS -u Administrator:password -X POST http://127.0.0.1:8091/sampleBuckets/install -d '["travel-sample"]'

echo "Configuration completed - Couchbase Admin UI: http://localhost:8091"

if [ "$TYPE" = "WORKER" ]; then
  sleep 15

  IP=`hostname -I`

  echo "Auto Rebalance: $AUTO_REBALANCE"
  if [ "$AUTO_REBALANCE" = "true" ]; then
    couchbase-cli rebalance --cluster=$COUCHBASE_MASTER:8091 --user=Administrator --password=password --server-add=$IP --server-add-username=Administrator --server-add-password=password
  else
    couchbase-cli server-add --cluster=$COUCHBASE_MASTER:8091 --user=Administrator --password=password --server-add=$IP --server-add-username=Administrator --server-add-password=password
  fi;
fi;

sv stop /etc/service/config-couchbase > /dev/null
