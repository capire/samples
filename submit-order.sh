#!/usr/bin/env bash

curl --request POST "http://localhost:4004/rest/browse/submitOrder" \
  --user "alice:alice" \
  --header "Content-Type: application/json" \
  --data "{\"book\": 201, \"quantity\": 1}" \
  -w "Response: %{http_code}"
echo