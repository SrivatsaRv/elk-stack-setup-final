#!/bin/bash

# Initialize counter
count=1

# Infinite loop to send the request every 30 seconds
while true; do
  # Construct the request field with a unique value
  count_field="$count"

  # Send the curl request
  curl -k -u elastic:changeme -X POST "https://localhost:9200/updated-logs-index/_doc?pretty" -H 'Content-Type: application/json' -d"
  {
  \"@timestamp\": \"$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")\",
  \"context\": {
    \"gamevariantid-nu\": 18776,
    \"playerstatus\": \"real\",
    \"accountname\": \"xyz\",
    \"label\": \"xyz\",
    \"count\": \"$count_field\",
    \"vendor\": \"IGT\",
    \"eventtime\": \"07-01-2025 05:33:44\"
  },
  \"app\": {
    \"version\": \"1.0\",
    \"name\": \"kpiserver\"
  },
  \"entry\": {
    \"level\": \"INFO\",
    \"useCase\": \"CASINO_GAME_COMPLETION_EVENT\",
    \"type\": \"FUNC\",
    \"class\": \"LOGSTASH_LOGGER\",
    \"dataCenter\": \"nj4\"
  }
  }
  "
  # Increment the counter for the next iteration
  count=$((count + 1))

  # Wait for 30 seconds
  sleep 30
done
