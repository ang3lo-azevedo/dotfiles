#!/usr/bin/env bash
# Brightness of one output: the given one, or the one the swaync control center is open on.
# Usage: monitor-brightness.sh get [OUTPUT] | set <0-100> [OUTPUT]

RUNTIME="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

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

case "$1" in
get)
	OUTPUT="${2:-$(cc_output)}"
	case "$OUTPUT" in
	eDP*) brightnessctl -c backlight -m | cut -d, -f4 | tr -d '%' ;;
	*) ddcutil --bus "$(ddc_bus "$OUTPUT")" getvcp 10 --brief | awk '{print $4}' ;;
	esac
	;;
set)
	OUTPUT="${3:-$(cc_output)}"
	case "$OUTPUT" in
	eDP*) brightnessctl -c backlight -q set "$2%" ;;
	*)
		BUS=$(ddc_bus "$OUTPUT") || exit 1
		STATE="$RUNTIME/monitor-brightness-$OUTPUT"
		echo "$2" >"$STATE"
		# DDC writes are far slower than slider drag events: a single worker
		# keeps applying the latest requested value, the other calls just record it
		exec 9>"$STATE.lock"
		flock -n 9 || exit 0
		applied=""
		while target=$(cat "$STATE") && [ "$target" != "$applied" ]; do
			ddcutil --bus "$BUS" --noverify setvcp 10 "$target"
			applied="$target"
		done
		;;
	esac
	;;
*)
	echo "Usage: $0 get [OUTPUT] | set <0-100> [OUTPUT]" >&2
	exit 1
	;;
esac
