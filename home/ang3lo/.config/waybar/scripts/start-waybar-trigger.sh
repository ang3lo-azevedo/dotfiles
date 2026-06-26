#!/usr/bin/env sh
OUTPUT="$1"
# trigger.jsonc uses the placeholder "EXTERNAL_OUTPUT"; substitute it with the actual
# output name so each physical display gets its own per-output Waybar instance
TEMP_CONFIG="/tmp/waybar-trigger-${OUTPUT}.jsonc"
sed "s/EXTERNAL_OUTPUT/${OUTPUT}/g" \
	~/.config/waybar/trigger.jsonc >"$TEMP_CONFIG"
exec waybar -c "$TEMP_CONFIG" -s ~/.config/waybar/trigger.css
