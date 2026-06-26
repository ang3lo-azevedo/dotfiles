#!/usr/bin/env bash
# Start a waybar instance for the given output, e.g. eDP-1 or DP-3.
# Usage: start-waybar-output.sh <OUTPUT_NAME>
OUTPUT="$1"
TEMP_CONFIG="/tmp/waybar-${OUTPUT}.jsonc"

sed "s/EXTERNAL_OUTPUT/${OUTPUT}/g" \
	~/.config/waybar/config.jsonc >"$TEMP_CONFIG"

waybar -c "$TEMP_CONFIG" -s ~/.config/waybar/style.css &
WAYBAR_PID=$!

# External monitors start hidden: the trigger bar is used to reveal them.
# eDP outputs are the built-in laptop screen and start expanded.
case "$OUTPUT" in
eDP*) ;;
*)
	sleep 1
	kill -SIGUSR1 $WAYBAR_PID
	;;
esac

# Forward SIGTERM so systemd can stop the service cleanly
trap 'kill $WAYBAR_PID' TERM INT
wait $WAYBAR_PID
