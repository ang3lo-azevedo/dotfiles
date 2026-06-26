#!/usr/bin/env sh

CONFIG_FILE="$HOME/.config/niri/config.kdl"

# Scan the niri config for an `off` directive inside the `touch { }` block.
# awk tracks block entry/exit because `off` appears in other blocks too and a plain
# grep would produce false positives
if awk '/touch *\{/ {in_block=1} in_block && /^[[:space:]]*off/ {found=1} in_block && /\}/ {if(found) exit 0; else exit 1}' "$CONFIG_FILE"; then
	STATE="disabled"
else
	STATE="enabled"
fi

if [ "$1" = "toggle" ]; then
	if [ "$STATE" = "enabled" ]; then
		# Add off
		sed -i '/touch *{/a\        off' "$CONFIG_FILE"
		STATE="disabled"
	else
		# Remove off
		sed -i '/touch *{/,/}/ s/^[[:space:]]*off//' "$CONFIG_FILE"
		STATE="enabled"
	fi
fi

if [ "$STATE" = "enabled" ]; then
	echo '{"text": "󰴽", "class": "enabled", "tooltip": "Touchscreen: Enabled"}'
else
	echo '{"text": "󰤟", "class": "disabled", "tooltip": "Touchscreen: Disabled"}'
fi
