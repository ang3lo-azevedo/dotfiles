#!/usr/bin/env bash

LOW_THRESHOLD=20
STATE_FILE="/tmp/kdeconnect_charging_state"
LOW_BAT_FILE="/tmp/kdeconnect_low_bat"

id=$(kdeconnect-cli -l --id-only 2>/dev/null | head -1)
[ -z "$id" ] && exit 1

if [ "$1" = "--ring" ]; then
	kdeconnect-cli -d "$id" --ring
	exit 0
fi

if [ "$1" = "--clipboard" ]; then
	kdeconnect-cli -d "$id" --share-text "$(wl-paste)"
	notify-send "KDE Connect" "Clipboard sent to phone"
	exit 0
fi

name=$(kdeconnect-cli -l 2>/dev/null | grep "$id" | sed 's/^- //; s/: .*//')

battery=$(busctl --user get-property org.kde.kdeconnect \
	/modules/kdeconnect/devices/"$id"/battery \
	org.kde.kdeconnect.device.battery charge 2>/dev/null | awk '{print $2}')
is_charging=$(busctl --user get-property org.kde.kdeconnect \
	/modules/kdeconnect/devices/"$id"/battery \
	org.kde.kdeconnect.device.battery isCharging 2>/dev/null | awk '{print $2}')

[[ -z $battery || $battery -lt 0 ]] 2>/dev/null && battery=0

idx=$((battery / 10))
((idx > 9)) && idx=9

if [ "$is_charging" = "true" ]; then
	alt="charging-$idx"
else
	alt="battery-$idx"
fi

if [ -f "$STATE_FILE" ]; then
	prev=$(cat "$STATE_FILE")
	if [ "$prev" = "true" ] && [ "$is_charging" = "false" ]; then
		notify-send "KDE Connect" "Charger disconnected ($name)"
	elif [ "$prev" = "false" ] && [ "$is_charging" = "true" ]; then
		notify-send "KDE Connect" "Charger connected ($name)"
		rm -f "$LOW_BAT_FILE"
	fi
fi
echo "$is_charging" >"$STATE_FILE"

if [ "$battery" -le "$LOW_THRESHOLD" ] && [ "$is_charging" != "true" ]; then
	if [ ! -f "$LOW_BAT_FILE" ]; then
		notify-send -u critical "KDE Connect" "Low battery: $battery% ($name)"
		touch "$LOW_BAT_FILE"
	fi
elif [ "$battery" -gt "$LOW_THRESHOLD" ]; then
	rm -f "$LOW_BAT_FILE"
fi

if [ "$battery" -le 20 ]; then
	class="critical"
elif [ "$battery" -le 50 ]; then
	class="warning"
else
	class="normal"
fi

printf '{"text":"","alt":"%s","class":"%s","tooltip":"%s · %d%%"}\n' \
	"$alt" "$class" "$name" "$battery"
