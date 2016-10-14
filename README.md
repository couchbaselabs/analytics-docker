Couchbase with NoSQL Analytics Service
======================================

# Running

You should need nothing installed on your machine except Docker. Type:

    docker run -d --name analytics -p 8095:8095 -v `pwd`/analytics_demo:/opt/couchbase/var couchbasesamples/analytics-demo

Then visit [http://localhost:8095/](http://localhost:8095/) for the Analytics Workbench.

You can run the command-line query tool cbq with:

    docker exec -it analytics cbq -e http://localhost:8095/

# Building your own

If you need a newer image based on a local Analytics build:

1. Copy a recent couchbase-analytics-*.zip into this directory.
2. Run "./go".


