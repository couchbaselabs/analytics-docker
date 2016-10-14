#!/bin/sh

if [ "${1}" != "analytics-demo" ]
then
  exec "$@"
fi

# Start Couchbase per normal
/entrypoint.sh couchbase-server &

# If this is the first time, configure Couchbase
if [ ! -e /opt/couchbase/var/analytics/couchbase-config-done ]
then
  sleep 3
  echo "Waiting for Couchbase Server to fully start..."
  sleep 10

  echo "Configuring Couchbase cluster quotas, services, and credentials.."

  # Setup index and memory quota
  curl -v http://127.0.0.1:8091/pools/default -d memoryQuota=300 -d indexMemoryQuota=300
  echo

  # Setup services
  curl -v http://127.0.0.1:8091/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex
  echo

  # Setup credentials
  curl -v http://127.0.0.1:8091/settings/web -d port=8091 -d username=Administrator -d password=password
  echo

  # Setup Memory Optimized Indexes
  curl -i -u Administrator:password http://127.0.0.1:8091/settings/indexes -d 'storageMode=memory_optimized'
  echo

  # Load beer-sample bucket
  echo
  echo
  echo "Loading beer-sample bucket..."
  curl -v -u Administrator:password http://127.0.0.1:8091/sampleBuckets/install -d '["beer-sample"]'
  echo

  # Create Analytics directories and ensure first-time setup isn't done again
  mkdir -p /opt/couchbase/var/analytics/logs
  touch /opt/couchbase/var/analytics/couchbase-config-done
  
  # Ensure everything is owned by the 'couchbase' user
  chown -R couchbase:couchbase /opt/couchbase/var/analytics
  echo "Done!"
  echo
fi

# Start up the sample Analytics cluster
su couchbase /opt/couchbase/cbas/samples/local/bin/start-sample-cluster.sh

# Let everything run
wait

