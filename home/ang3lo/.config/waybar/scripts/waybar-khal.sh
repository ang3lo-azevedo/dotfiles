#!/usr/bin/env bash

# This script outputs today's and tomorrow's events from khal in Waybar JSON format.

# Check if khal is installed
if ! command -v khal &> /dev/null; then
    echo '{"text": "󰃭 ?", "tooltip": "Khal is not installed or not in PATH"}'
    exit 0
fi

# Fetch today's agenda
agenda=$(khal list today tomorrow --format "{start-end-time-style} {title}")

# If no events
if [[ -z "$agenda" || "$agenda" == *"No events"* ]]; then
    echo '{"text": "󰃭", "tooltip": "No upcoming events", "class": "empty"}'
    exit 0
fi

# We have events!
# Create a simple icon, you could change this to show the next event time if preferred
text="󰃭"

# Escape quotes and newlines for JSON tooltip
tooltip=$(echo "$agenda" | sed -E 's/"/\\"/g; s/$/\\n/g' | tr -d '\n')
# Remove trailing \n
tooltip=${tooltip%\\n}

echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\", \"class\": \"events\"}"
