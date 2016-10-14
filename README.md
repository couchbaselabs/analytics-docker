Couchbase with NoSQL Analytics Service
======================================

# Building

1. Copy a recent couchbase-analytics-*.zip into this directory.
2. Run "./go".

# Running

    docker run -d -p 8095:8095 -v `pwd`/analytics_demo:/opt/couchbase/var couchbasesamples/analytics-demo

Then visit http://localhost:8095/ for the Analytics Workbench.

