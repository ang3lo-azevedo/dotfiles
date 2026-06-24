#!/usr/bin/env bash

# Run a background process to update the agenda tooltip every 60 seconds
update_tooltip() {
    while true; do
        agenda=$(khal list today tomorrow --format "{start-end-time-style} {title}" 2>/dev/null)
        if [[ -z "$agenda" || "$agenda" == *"No events"* ]]; then
            echo "No upcoming events" > /tmp/waybar_agenda_tooltip
        else
            tooltip=$(echo "$agenda" | sed -E 's/"/\\"/g; s/$/\\n/g' | tr -d '\n')
            echo "${tooltip%\\n}" > /tmp/waybar_agenda_tooltip
        fi
        sleep 60
    done
}

# Kill background process on exit
trap 'kill $(jobs -p)' EXIT

update_tooltip &

# Main loop to update the clock every second
while true; do
    time=$(date +"%d.%m %H:%M:%S")
    if [[ -f /tmp/waybar_agenda_tooltip ]]; then
        tooltip=$(cat /tmp/waybar_agenda_tooltip)
    else
        tooltip="Loading events..."
    fi
    echo "{\"text\": \"$time\", \"tooltip\": \"$tooltip\", \"class\": \"clock-calendar\"}"
    sleep 1
done
