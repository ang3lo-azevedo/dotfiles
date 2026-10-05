#!/usr/bin/env bash
# Brightness of one output: the given one, or the one the swaync control center is open on.
# With the "all" mode on, set and step without an OUTPUT apply to every connected output.
# "step" is for the brightness keys: without an OUTPUT and with the "all" mode off, it acts on the focused output.
# "auto" is wluma, which lowers the brightness set here depending on the screen content and time of day.
# "off" powers the screens off and puts their brightness back when they wake: some forget it (see restore_output).
# Usage: monitor-brightness.sh get [OUTPUT] | set <0-100> [OUTPUT] | step <up|down> [OUTPUT] | mode [toggle] | auto [toggle]
#        monitor-brightness.sh save | restore [OUTPUT] | off

RUNTIME="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
ALL_MODE="$RUNTIME/monitor-brightness-all"
# Checked by the wluma unit (wluma.nix) so it also stays off across logins
AUTO_OFF="${XDG_STATE_HOME:-$HOME/.local/state}/wluma-disabled"

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

# The MP165 draws its power from the USB cable and browns out at full brightness:
# it drops the link within seconds at 100, 80 is the highest value known to hold
max_brightness() {
	case "$(niri msg --json outputs | jq -r --arg output "$1" '.[$output].model // empty')" in
	"MSI MP165 E6") echo 80 ;;
	*) echo 100 ;;
	esac
}

set_output() {
	local bus state target applied="" value=$2 max
	case "$1" in
	eDP*) brightnessctl -c backlight -q set "$2%" ;;
	*)
		bus=$(ddc_bus "$1") || return 1
		max=$(max_brightness "$1")
		[ "$value" -gt "$max" ] && value=$max
		state="$RUNTIME/monitor-brightness-$1"
		echo "$value" >"$state"
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

# Read back once the keys are released: a read after every press would slow down a held key
record_later() {
	local state="$RUNTIME/monitor-brightness-$1" stamp current
	stamp=$(date +%s%N)
	echo "$stamp" >"$state.pending"
	(
		sleep 1
		[ "$(cat "$state.pending")" = "$stamp" ] || exit 0
		current=$(ddcutil --bus "$2" getvcp 10 --brief | awk '{print $4}')
		[[ $current =~ ^[0-9]+$ ]] && echo "$current" >"$state"
	) >/dev/null 2>&1 9>&- &
}

ddc_outputs() {
	niri msg --json outputs | jq -r 'keys[] | select(startswith("eDP") | not)'
}

# Records what each screen is at now, for restore_output.
# wluma and the screen's own buttons change the brightness behind this script's back
save_outputs() {
	local output bus current
	for output in $(ddc_outputs); do
		# A screen in standby may answer with anything
		grep -qsx On /sys/class/drm/card*-"$output"/dpms || continue
		bus=$(ddc_bus "$output") || continue
		current=$(ddcutil --bus "$bus" getvcp 10 --brief 2>/dev/null | awk '{print $4}')
		[[ $current =~ ^[0-9]+$ ]] && echo "$current" >"$RUNTIME/monitor-brightness-$output"
	done
}

# The G27C4 does not keep a brightness set over DDC: after a power-off or a replug
# it comes back at the one from its own menu. Puts back the last one recorded here.
restore_output() {
	local bus saved current
	saved=$(cat "$RUNTIME/monitor-brightness-$1" 2>/dev/null)
	[ -n "$saved" ] || return 0
	# It still reports the old value for a couple of seconds after waking, then jumps:
	# keep looking for a while and put it back once
	for _ in 1 2 3 4 5 6 7 8 9 10; do
		bus=$(ddc_bus "$1") && current=$(ddcutil --bus "$bus" getvcp 10 --brief 2>/dev/null | awk '{print $4}')
		if [[ $current =~ ^[0-9]+$ ]] && [ "$current" != "$saved" ]; then
			set_output "$1" "$saved"
			return
		fi
		sleep 2
	done
}

step_output() {
	local bus sign=+ max current target
	[ "$2" = down ] && sign=-
	case "$1" in
	eDP*) brightnessctl -c backlight -q set "2%$sign" ;;
	*)
		bus=$(ddc_bus "$1") || return 1
		# A held key repeats faster than DDC can write: presses that arrive during a write are dropped,
		# queueing them would keep changing the brightness long after the key is released.
		# Not the lock of set_output, which would drop a slider value while a key press is being applied
		exec 9>"$RUNTIME/monitor-brightness-$1.step.lock"
		flock -n 9 || return 0
		max=$(max_brightness "$1")
		if [ "$sign" = + ] && [ "$max" -lt 100 ]; then
			# A relative step cannot be capped, and reading first is too slow to do for every screen
			current=$(ddcutil --bus "$bus" getvcp 10 --brief | awk '{print $4}')
			[ -n "$current" ] || return 1
			target=$((current + 5))
			[ "$target" -gt "$max" ] && target=$max
			ddcutil --bus "$bus" --noverify setvcp 10 "$target"
		else
			ddcutil --bus "$bus" --noverify setvcp 10 "$sign" 5
		fi
		record_later "$1" "$bus"
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
step)
	if [ -n "$3" ]; then
		step_output "$3" "$2"
	elif [ -e "$ALL_MODE" ]; then
		for output in $(niri msg --json outputs | jq -r 'keys[]'); do
			(step_output "$output" "$2") &
		done
		wait
	else
		step_output "$(niri msg --json focused-output | jq -r '.name')" "$2"
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
auto)
	if [ "$2" = toggle ]; then
		# swaync passes the new state of its toggle button, anything else just flips
		case "${SWAYNC_TOGGLE_STATE:-$(systemctl --user is-active --quiet wluma && echo false || echo true)}" in
		true)
			rm -f "$AUTO_OFF"
			# Quick clicks would otherwise trip systemd's start limit
			systemctl --user reset-failed wluma
			systemctl --user start wluma
			;;
		*)
			mkdir -p "$(dirname "$AUTO_OFF")" && touch "$AUTO_OFF"
			systemctl --user stop wluma
			save_outputs
			;;
		esac
	else
		systemctl --user is-active --quiet wluma && echo true || echo false
	fi
	;;
save)
	save_outputs
	;;
restore)
	# Each output in its own subshell: they must not share the lock descriptor
	for output in ${2:-$(ddc_outputs)}; do
		(restore_output "$output") &
	done
	wait
	;;
off)
	save_outputs
	niri msg action power-off-monitors
	# In the background: swayidle waits for its commands, and the screens may stay off for hours
	(
		exec 9>"$RUNTIME/monitor-brightness-off.lock"
		flock -n 9 || exit 0
		sleep 3
		# Only the connected ones: a writeback connector always reads On
		until for output in $(niri msg --json outputs | jq -r 'keys[]'); do
			grep -qsx On /sys/class/drm/card*-"$output"/dpms && break
		done; do sleep 1; done
		exec 9>&-
		"$0" restore
	) >/dev/null 2>&1 &
	;;
*)
	echo "Usage: $0 get [OUTPUT] | set <0-100> [OUTPUT] | step <up|down> [OUTPUT] | mode [toggle] | auto [toggle] | save | restore [OUTPUT] | off" >&2
	exit 1
	;;
esac
