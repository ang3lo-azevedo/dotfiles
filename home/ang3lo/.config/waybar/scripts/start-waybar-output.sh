#!/usr/bin/env sh
# Start a waybar instance for the given output, e.g. eDP-1 or DP-3.
# Usage: start-waybar-output.sh <OUTPUT_NAME>
OUTPUT="$1"
TEMP_CONFIG="/tmp/waybar-${OUTPUT}.jsonc"

sed "s/EXTERNAL_OUTPUT/${OUTPUT}/g" \
	~/.config/waybar/config.jsonc >"$TEMP_CONFIG"

exec waybar -c "$TEMP_CONFIG" -s ~/.config/waybar/style.css
