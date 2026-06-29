#!/usr/bin/env bash
set -euo pipefail
for dev in /sys/class/input/*/device; do
	name=$(cat "$dev/name" 2>/dev/null || true)
	[[ $name != *"Touchpad"* ]] && continue
	inhibit="$dev/inhibited"
	[ -f "$inhibit" ] || continue
	if [ "$(cat "$inhibit")" = "0" ]; then
		echo 1 >"$inhibit"
		notify-send -t 2000 "Touchpad" "Disabled"
	else
		echo 0 >"$inhibit"
		notify-send -t 2000 "Touchpad" "Enabled"
	fi
	exit 0
done
