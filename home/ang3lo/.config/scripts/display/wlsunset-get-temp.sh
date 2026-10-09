#!/usr/bin/env bash
# Night light strength as 0-100, 0 when wlsunset is off
if ! systemctl --user is-active --quiet wlsunset; then
	echo 0
	exit
fi
runtime="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
temp=$(cat "$runtime/wlsunset-night-temp" 2>/dev/null || echo 2500)
level=$(((6500 - temp + 25) / 50))

DISABLED="${XDG_STATE_HOME:-$HOME/.local/state}/wlsunset-auto-disabled"
# If disabled, wlsunset holds night temp all day.
if [ -e "$DISABLED" ]; then
	echo "$level"
	exit
fi

read -r start sunset sunrise <"$runtime/wlsunset-sun-times" 2>/dev/null
if [ -z "$start" ]; then
	echo "$level"
	exit
fi

minutes() { echo $((10#${1%:*} * 60 + 10#${1#*:})); }
start=$(minutes "$start")
sunset=$(minutes "$sunset")
sunrise=$(minutes "$sunrise")
now=$(minutes "$(date +%H:%M)")

diff_minutes() {
	local diff=$(($1 - $2))
	[ "$diff" -lt 0 ] && diff=$((diff + 1440))
	echo "$diff"
}

is_between() {
	local t=$1 a=$2 b=$3
	if [ "$a" -le "$b" ]; then
		[ "$t" -ge "$a" ] && [ "$t" -lt "$b" ]
	else
		[ "$t" -ge "$a" ] || [ "$t" -lt "$b" ]
	fi
}

duration=$(diff_minutes "$sunset" "$start")
[ "$duration" -eq 0 ] && duration=1

if is_between "$now" "$start" "$sunset"; then
	progress=$(diff_minutes "$now" "$start")
	echo $((level * progress / duration))
else
	# wlsunset fades back to day over the same duration, ending at sunrise
	dawn=$(((sunrise - duration + 1440) % 1440))
	if is_between "$now" "$sunset" "$dawn"; then
		echo "$level"
	elif is_between "$now" "$dawn" "$sunrise"; then
		progress=$(diff_minutes "$now" "$dawn")
		echo $((level * (duration - progress) / duration))
	else
		echo 0
	fi
fi
