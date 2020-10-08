#!/bin/bash

CONNECT_HOST=connect

until curl http://$CONNECT_HOST:8083/connectors 2>&1; do
    echo "Connect not ready yet"
    sleep 15
done

curl -v --retry 100 -XPOST -H "Content-Type: application/json" -d '
{
  "name": "mqtt-messages-connector",
  "config": {
    "batch.size": 100,
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "tasks.max": "1",
    "schema.ignore": "true",
    "key.ignore": "true",
    "topics": "mqtt_messages",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "key.converter.schemas.enable":true,
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "false",
    "connection.url": "http://elasticsearch7:9200",
    "type.name": "mqtt-message",
    "name": "mqtt-messages-connector"
  }
}' http://$CONNECT_HOST:8083/connectors


