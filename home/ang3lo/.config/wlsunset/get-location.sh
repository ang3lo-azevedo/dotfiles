#!/usr/bin/env bash

CACHE_FILE="$HOME/.cache/wlsunset_location.json"
mkdir -p "$(dirname "$CACHE_FILE")"

# Try to fetch current location
RETRIES=5
counter=0
CONTENT=""
while [ $counter -lt $RETRIES ]; do
    if CONTENT=$(curl --connect-timeout 2 --max-time 5 -s http://ip-api.com/json/); then
        status=$(echo "$CONTENT" | jq -r .status 2>/dev/null)
        if [ "$status" = "success" ]; then
            echo "$CONTENT" > "$CACHE_FILE"
            break
        fi
    fi
    counter=$((counter + 1))
    sleep 2
done

if [ -z "$CONTENT" ] || [ "$status" != "success" ]; then
    echo "Unable to fetch location, attempting to use cache." >&2
    if [ -f "$CACHE_FILE" ]; then
        CONTENT=$(cat "$CACHE_FILE")
    else
        echo "No cache found. Using default coordinates (Lisbon)." >&2
        CONTENT='{"lat": 38.7223, "lon": -9.1393}'
    fi
fi

longitude=$(echo "$CONTENT" | jq -r .lon)
latitude=$(echo "$CONTENT" | jq -r .lat)

if [ -z "$latitude" ] || [ -z "$longitude" ] || [ "$latitude" = "null" ] || [ "$longitude" = "null" ]; then
  echo "Failed to extract coordinates, using default (Lisbon)." >&2
  latitude=38.7223
  longitude=-9.1393
fi

echo "$latitude $longitude"
