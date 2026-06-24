#!/usr/bin/env bash

# File used to mark as dismissed
DISMISS_FILE="/tmp/waybar-mpris-dismiss"
rm -f "$DISMISS_FILE"

# Background job to clear the dismiss file when track changes
playerctl metadata --follow --format '{{title}} - {{artist}}' 2>/dev/null | while read -r line; do
    rm -f "$DISMISS_FILE"
done &
PLAYERCTL_PID=$!

# Ensure background job is killed on exit
trap 'kill $PLAYERCTL_PID 2>/dev/null' EXIT

# Run ScrollMPRIS and filter output
ScrollMPRIS --scroll wrapping | while read -r line; do
    if [ -f "$DISMISS_FILE" ]; then
        # When dismissed, output an empty text to hide the module
        echo '{"text": "", "tooltip": "Dismissed. Will return on next song."}'
    else
        echo "$line"
    fi
done
