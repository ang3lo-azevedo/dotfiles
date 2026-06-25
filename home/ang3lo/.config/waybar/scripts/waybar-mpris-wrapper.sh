#!/usr/bin/env bash

# Files used to mark state
DISMISS_FILE="/tmp/waybar-mpris-dismiss"
SHOW_FILE="/tmp/waybar-mpris-show"

# Background job to clear the states when track changes
playerctl metadata --follow --format '{{title}} - {{artist}}' 2>/dev/null | while read -r line; do
	rm -f "$DISMISS_FILE" "$SHOW_FILE"
done &
PLAYERCTL_PID=$!

# Ensure background job is killed on exit
trap 'kill $PLAYERCTL_PID 2>/dev/null' EXIT

# Run ScrollMPRIS and filter output
ScrollMPRIS --no-icon --scroll wrapping | while read -r line; do
	if [ -f "$DISMISS_FILE" ]; then
		# Explicitly dismissed
		echo '{"text": "", "tooltip": "Dismissed."}'
	elif [ -f "$SHOW_FILE" ]; then
		# Explicitly shown (even if paused)
		echo "$line"
	elif [[ $line == *'"class":"paused"'* ]]; then
		# Default behavior: hide when paused
		echo '{"text": "", "tooltip": "Paused"}'
	else
		# Default behavior: show when playing
		echo "$line"
	fi
done
