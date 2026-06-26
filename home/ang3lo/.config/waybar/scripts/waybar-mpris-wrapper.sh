#!/usr/bin/env bash

# Dismiss/show state is stored as flag files so the right-click binding (which runs a
# separate process) can signal this loop without IPC or a named pipe
DISMISS_FILE="/tmp/waybar-mpris-dismiss"
SHOW_FILE="/tmp/waybar-mpris-show"

# Reset dismiss/show overrides whenever the track changes so each new song starts visible
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
