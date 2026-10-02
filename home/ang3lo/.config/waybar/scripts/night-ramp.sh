#!/usr/bin/env bash
# Dims every screen in small steps over the same window in which wlsunset fades in the night light,
# so each one reaches END_BRIGHTNESS at sunset, then undoes it at sunrise.
# Run every few minutes by the night-ramp timer.
# Changes are relative, so adjusting the brightness by hand in between is kept.
# Can be switched off, which also makes wlsunset hold the night light on all day.
# Usage: night-ramp.sh [HH:MM]   (the time to pretend it is, for testing)
#        night-ramp.sh mode [toggle]

STEPS=12
# Where every screen ends up at sunset: low enough for a completely dark room.
# Screens already at or below it are left alone.
END_BRIGHTNESS=15

SCRIPTS=$(dirname "$(readlink -f "$0")")
RUNTIME="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
# First line: steps applied so far. Then one "output brightness" line per screen, as it was when the ramp began.
# Screens remember their brightness across a reboot, so this bookkeeping must survive one too
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/night-ramp-brightness"
# Also read by wlsunset-auto (wlsunset.nix)
DISABLED="${XDG_STATE_HOME:-$HOME/.local/state}/night-ramp-disabled"

if [ "$1" = mode ]; then
	if [ "$2" != toggle ]; then
		[ -e "$DISABLED" ] && echo false || echo true
		exit
	fi
	# swaync passes the new state of its toggle button, anything else just flips
	case "${SWAYNC_TOGGLE_STATE:-$([ -e "$DISABLED" ] && echo true || echo false)}" in
	true) rm -f "$DISABLED" ;;
	*) mkdir -p "$(dirname "$DISABLED")" && touch "$DISABLED" ;;
	esac
	# A few quick clicks would otherwise trip systemd's start limit and leave wlsunset dead:
	# only the last click restarts it, with the limit cleared
	pending="$RUNTIME/night-ramp-pending"
	stamp=$(date +%s%N)
	echo "$stamp" >"$pending"
	(
		sleep 0.5
		[ "$(cat "$pending")" = "$stamp" ] || exit 0
		was_active=$(systemctl --user is-active wlsunset)
		systemctl --user reset-failed wlsunset
		# "failed" here means an earlier start-limit hit, not that the night light was switched off
		if [ "$was_active" = active ] || [ "$was_active" = failed ]; then
			systemctl --user restart wlsunset
		fi
		# Apply or undo the dimming right away instead of waiting for the timer
		"$0"
	) >/dev/null 2>&1 &
	exit
fi

exec 9>"$RUNTIME/night-ramp.lock"
flock -n 9 || exit 0

minutes() { echo $((10#${1%:*} * 60 + 10#${1#*:})); }

# Written by wlsunset-auto (wlsunset.nix) every time wlsunset starts
read -r start sunset sunrise <"$RUNTIME/wlsunset-sun-times" 2>/dev/null
start=$(minutes "${start:-17:00}")
sunset=$(minutes "${sunset:-19:00}")
sunrise=$(minutes "${sunrise:-07:00}")
now=$(minutes "${1:-$(date +%H:%M)}")

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

target=0
# Night light switched off means no night mode at all: screens go back to normal too.
# wluma owns the brightness while it runs: dimming under it would be learned as a preference and drift.
if [ ! -e "$DISABLED" ] && systemctl --user is-active --quiet wlsunset && ! systemctl --user is-active --quiet wluma; then
	duration=$(diff_minutes "$sunset" "$start")
	[ "$duration" -eq 0 ] && duration=1

	if is_between "$now" "$start" "$sunset"; then
		progress=$(diff_minutes "$now" "$start")
		target=$((progress * STEPS / duration))
	elif is_between "$now" "$sunset" "$sunrise"; then
		target=$STEPS
	fi
fi

applied=$(head -n 1 "$STATE" 2>/dev/null)
applied=${applied:-0}
[ "$target" -ne "$applied" ] || exit 0

declare -A base
if [ "$applied" -eq 0 ]; then
	for output in $(niri msg --json outputs | jq -r 'keys[]'); do
		value=$("$SCRIPTS/monitor-brightness.sh" get "$output")
		[ -n "$value" ] && base[$output]=$value
	done
else
	while read -r output value; do
		base[$output]=$value
	done < <(tail -n +2 "$STATE")
fi

for output in "${!base[@]}"; do
	range=$((base[$output] - END_BRIGHTNESS))
	[ "$range" -gt 0 ] || continue
	# Empty when the screen has been unplugged since the ramp began
	current=$("$SCRIPTS/monitor-brightness.sh" get "$output")
	[ -n "$current" ] || continue
	new=$((current - range * target / STEPS + range * applied / STEPS))
	[ "$new" -gt 100 ] && new=100
	[ "$new" -lt 1 ] && new=1
	"$SCRIPTS/monitor-brightness.sh" set "$new" "$output"
done

mkdir -p "$(dirname "$STATE")"
{
	echo "$target"
	if [ "$target" -gt 0 ]; then
		for output in "${!base[@]}"; do
			echo "$output ${base[$output]}"
		done
	fi
} >"$STATE"
