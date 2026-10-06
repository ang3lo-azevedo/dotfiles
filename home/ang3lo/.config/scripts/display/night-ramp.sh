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
# One "steps brightness screen" line per dimmed screen: steps applied so far and its brightness when its ramp began.
# Kept per screen so one plugged in after the ramp started is dimmed too.
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
		# Apply or undo the dimming right away instead of waiting for the timer
		"$0"
	) >/dev/null 2>&1 &
	exit
fi

exec 9>"$RUNTIME/night-ramp.lock"
flock -n 9 || exit 0

minutes() { echo $((10#${1%:*} * 60 + 10#${1#*:})); }

# Through the journal rather than stderr: the run started by the toggle has no output
# Read with: journalctl -t night-ramp
log() { logger -t night-ramp -- "$*"; }

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
AUTO_OFF="${XDG_STATE_HOME:-$HOME/.local/state}/wluma-disabled"
# Night light switched off means no night mode at all: screens go back to normal too.
if [ ! -e "$DISABLED" ] && systemctl --user is-active --quiet wlsunset; then
	duration=$(diff_minutes "$sunset" "$start")
	[ "$duration" -eq 0 ] && duration=1

	if is_between "$now" "$start" "$sunset"; then
		progress=$(diff_minutes "$now" "$start")
		target=$((progress * STEPS / duration))
	elif is_between "$now" "$sunset" "$sunrise"; then
		target=$STEPS
	fi
fi

if [ "$target" -gt 0 ] && systemctl --user is-active --quiet wluma; then
	# wluma owns the brightness while it runs: dimming under it would be learned as a preference and drift.
	# So we automatically pause wluma at night.
	systemctl --user stop wluma
	touch "$RUNTIME/night-ramp-stopped-wluma"
fi

declare -A base applied
while read -r steps value id; do
	[ -n "$id" ] || continue
	applied[$id]=$steps
	base[$id]=$value
done <"$STATE" 2>/dev/null

# Screens are keyed by make, model and serial: connector names change when the dock or eGPU is replugged
while IFS=$'\t' read -r output id; do
	[ -n "${id// /}" ] || id=$output
	steps=${applied[$id]:-0}
	[ "$steps" -ne "$target" ] || continue
	# Empty when the screen does not answer, it is retried on the next run
	current=$("$SCRIPTS/monitor-brightness.sh" get "$output")
	if [ -z "$current" ]; then
		log "$output: no answer, step $steps to $target is retried on the next run"
		continue
	fi
	[ "$steps" -eq 0 ] && base[$id]=$current
	end_b=$END_BRIGHTNESS
	[[ $id == *"MSI MP165 E6"* ]] && end_b=1
	range=$((base[$id] - end_b))
	if [ "$range" -gt 0 ]; then
		new=$((current - range * target / STEPS + range * steps / STEPS))
		[ "$new" -gt 100 ] && new=100
		[ "$new" -lt 1 ] && new=1
		"$SCRIPTS/monitor-brightness.sh" set "$new" "$output"
		log "$output: step $steps to $target, brightness $current to $new (started at ${base[$id]})"
	else
		log "$output: step $steps to $target, left alone (started at ${base[$id]}, not above $end_b)"
	fi
	applied[$id]=$target
done < <(niri msg --json outputs | jq -r 'to_entries[] | [.key, ([.value.make, .value.model, .value.serial] | map(select(. != null and . != "")) | join(" "))] | @tsv')

mkdir -p "$(dirname "$STATE")"
for id in "${!applied[@]}"; do
	# Not a bare "&&": a false test on the last screen would become the exit status
	if [ "${applied[$id]}" -gt 0 ]; then echo "${applied[$id]} ${base[$id]} $id"; fi
done >"$STATE"

# Only now that the screens are back up: wluma starts from the brightness it finds
if [ "$target" -eq 0 ] && [ -e "$RUNTIME/night-ramp-stopped-wluma" ]; then
	rm -f "$RUNTIME/night-ramp-stopped-wluma"
	if [ ! -e "$AUTO_OFF" ]; then
		# That brightness dates from when the ramp began. Told so, wluma moves on from there
		# to what this time of day calls for, instead of holding it (wluma.nix)
		systemctl --user set-environment WLUMA_START_HOUR=$((start / 60))
		systemctl --user reset-failed wluma
		systemctl --user start wluma
		systemctl --user unset-environment WLUMA_START_HOUR
	fi
fi
