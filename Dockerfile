FROM couchbase/server-internal:6.0.0-1331

MAINTAINER Chris Hillery <ceej@couchbase.com>

# Add runit script for couchbase-server node configuration
COPY scripts/configure-node.sh /etc/service/config-couchbase/run
