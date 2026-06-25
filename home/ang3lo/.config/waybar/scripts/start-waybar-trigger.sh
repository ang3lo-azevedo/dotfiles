#!/usr/bin/env sh
OUTPUT="$1"
TEMP_CONFIG="/tmp/waybar-trigger-${OUTPUT}.jsonc"
sed "s/EXTERNAL_OUTPUT/${OUTPUT}/g" \
	~/.config/waybar/trigger.jsonc >"$TEMP_CONFIG"
exec waybar -c "$TEMP_CONFIG" -s ~/.config/waybar/trigger.css
