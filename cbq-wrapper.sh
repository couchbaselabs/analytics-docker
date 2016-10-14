#!/bin/bash

exec /opt/couchbase/cbas/bin/cbq -e http://localhost:8095/ $@

