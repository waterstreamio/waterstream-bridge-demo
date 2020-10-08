#!/bin/bash

KIBANA_HOST=kibana7

until curl http://$KIBANA_HOST:5601/ 2>&1; do
    echo "Kibana not ready yet"
    sleep 15
done

curl --retry 100 -v -X POST http://$KIBANA_HOST:5601/api/saved_objects/_import?overwrite=true -H "kbn-xsrf: true" --form file=@/etc/kibana/export.ndjson