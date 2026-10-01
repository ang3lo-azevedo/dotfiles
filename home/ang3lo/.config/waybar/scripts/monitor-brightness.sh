#!/usr/bin/env bash
# Brightness of one output: the given one, or the one the swaync control center is open on.
# With the "all" mode on, set without an OUTPUT applies to every connected output.
# Usage: monitor-brightness.sh get [OUTPUT] | set <0-100> [OUTPUT] | mode [toggle]

RUNTIME="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
ALL_MODE="$RUNTIME/monitor-brightness-all"

cc_output() {
	local out
	# swaync maps a click-catcher surface on every other output too: only the real panel takes keyboard focus.
	# The getter fires while the panel is still opening, before its layer surface is mapped
	for _ in 1 2 3 4 5 6 7 8 9 10; do
		out=$(niri msg --json layers | jq -r 'first(.[] | select(.namespace == "swaync-control-center" and .keyboard_interactivity != "None") | .output) // empty')
		[ -n "$out" ] && break
		sleep 0.05
	done
	[ -n "$out" ] || out=$(niri msg --json focused-output | jq -r '.name')
	echo "$out"
}

ddc_bus() {
	local dev
	# On DisplayPort only the AUX bus (i2c-N child) answers DDC, the "ddc" link points at a dead bus
	for dev in /sys/class/drm/card*-"$1"/i2c-* /sys/class/drm/card*-"$1"/ddc; do
		[ -e "$dev" ] || continue
		dev=$(readlink -f "$dev")
		echo "${dev##*/i2c-}"
		return
	done
	return 1
}

set_output() {
	local bus state target applied=""
	case "$1" in
	eDP*) brightnessctl -c backlight -q set "$2%" ;;
	*)
		bus=$(ddc_bus "$1") || return 1
		state="$RUNTIME/monitor-brightness-$1"
		echo "$2" >"$state"
		# DDC writes are far slower than slider drag events: a single worker
		# keeps applying the latest requested value, the other calls just record it
		exec 9>"$state.lock"
		flock -n 9 || return 0
		while target=$(cat "$state") && [ "$target" != "$applied" ]; do
			ddcutil --bus "$bus" --noverify setvcp 10 "$target"
			applied="$target"
		done
		;;
	esac
}

case "$1" in
get)
	OUTPUT="${2:-$(cc_output)}"
	case "$OUTPUT" in
	eDP*) brightnessctl -c backlight -m | cut -d, -f4 | tr -d '%' ;;
	*) ddcutil --bus "$(ddc_bus "$OUTPUT")" getvcp 10 --brief | awk '{print $4}' ;;
	esac
	;;
set)
	if [ -n "$3" ]; then
		set_output "$3" "$2"
	elif [ -e "$ALL_MODE" ]; then
		# Each output in its own subshell: they must not share the lock descriptor
		for output in $(niri msg --json outputs | jq -r 'keys[]'); do
			(set_output "$output" "$2") &
		done
		wait
	else
		set_output "$(cc_output)" "$2"
	fi
	;;
mode)
	if [ "$2" = toggle ]; then
		# swaync passes the new state of its toggle button, anything else just flips
		case "${SWAYNC_TOGGLE_STATE:-$([ -e "$ALL_MODE" ] && echo false || echo true)}" in
		true) touch "$ALL_MODE" ;;
		*) rm -f "$ALL_MODE" ;;
		esac
	else
		[ -e "$ALL_MODE" ] && echo true || echo false
	fi
	;;
*)
	echo "Usage: $0 get [OUTPUT] | set <0-100> [OUTPUT] | mode [toggle]" >&2
	exit 1
	;;
esac
