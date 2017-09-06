#!/bin/sh

echo "Configuring Couchbase Server.  Please wait (~60 sec)..."

export PATH=/opt/couchbase/bin:${PATH}

# Log all subsequent commands to logfile. FD 3 is now the console
# for things we want to show up in "docker logs".
LOGFILE=/opt/couchbase/var/lib/couchbase/logs/container-startup.log
exec 3>&1 1>>${LOGFILE} 2>&1

while true; do
  status=$(curl -s -w "%{http_code}" -o /dev/null http://127.0.0.1:8091/ui/index.html)
  if [ "x$status" = "x200" ]; then
    break
  fi
  echo "Server not up yet, waiting 2 seconds..."
  sleep 2
done

echo "Setting memory quotas with curl:"
curl -sS http://127.0.0.1:8091/pools/default -d memoryQuota=300 -d indexMemoryQuota=500 -d cbasMemoryQuota=1024
echo

echo "Configuring Services with curl:"
curl -sS http://127.0.0.1:8091/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex%2Ccbas
echo

echo "Setting up credentials with curl:"
curl -sS http://127.0.0.1:8091/settings/web -d port=8091 -d username=Administrator -d password=password
echo

echo "Enabling memory-optimized indexes with curl:"
curl -sS -i -u Administrator:password -X POST http://127.0.0.1:8091/settings/indexes -d 'storageMode=memory_optimized'
echo

echo "Loading beer-sample with curl:"
curl -sS -u Administrator:password -X POST http://127.0.0.1:8091/sampleBuckets/install -d '["beer-sample"]'
echo

echo "Loading travel-sample with curl:"
curl -sS -u Administrator:password -X POST http://127.0.0.1:8091/sampleBuckets/install -d '["travel-sample"]'
echo

echo "Configuration completed - Couchbase Admin UI: http://localhost:8091" | tee /dev/fd/3

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

echo "Stopping config-couchbase service"
sv stop /etc/service/config-couchbase
