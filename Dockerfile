FROM couchbase/server:5.5.0-Mar

MAINTAINER Chris Hillery <ceej@couchbase.com>

# Add runit script for couchbase-server node configuration
COPY scripts/configure-node.sh /etc/service/config-couchbase/run
