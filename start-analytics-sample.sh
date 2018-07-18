#!/bin/sh

# Launches the sample. Currently deployed on mega2.
docker run --detach=true --publish=9091-9095:8091-8095 \
  --name analytics-sample-$(date '+%Y%m%d') \
  --restart=unless-stopped \
  --volume /home/couchbase/slaves/analytics-sample:/opt/couchbase/var \
  --volume=/etc/timezone:/etc/timezone:ro \
  --volume=/etc/localtime:/etc/localtime:ro \
  couchbase/analytics-demo:6.0.0-1331

