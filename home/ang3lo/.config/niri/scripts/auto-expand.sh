#!/usr/bin/env bash
# auto-expand.sh - Auto expand new windows in Niri

# Keep track of seen window IDs to avoid re-expanding when only properties change
declare -A seen_windows

niri msg --json event-stream | while read -r line; do
	# Check if the event is a WindowOpenedOrChanged event
	if echo "$line" | jq -e '.WindowOpenedOrChanged' >/dev/null 2>&1; then
		window_id=$(echo "$line" | jq -r '.WindowOpenedOrChanged.window.id // empty')

		if [[ -n $window_id && -z ${seen_windows[$window_id]} ]]; then
			seen_windows[$window_id]=1
			# Add a small delay to ensure the window has been fully mapped
			sleep 0.1
			# Expand the column to available width
			niri msg action expand-column-to-available-width
		fi
	elif echo "$line" | jq -e '.WindowClosed' >/dev/null 2>&1; then
		window_id=$(echo "$line" | jq -r '.WindowClosed.id // empty')
		if [[ -n $window_id ]]; then
			unset "seen_windows[$window_id]"
		fi
	fi
done
