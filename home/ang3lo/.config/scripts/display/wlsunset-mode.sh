#!/usr/bin/env bash
DISABLED="${XDG_STATE_HOME:-$HOME/.local/state}/wlsunset-auto-disabled"
SCRIPTS=$(dirname "$(readlink -f "$0")")
RUNTIME="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
TEMP="$RUNTIME/wlsunset-night-temp"
# Night temperature to go back to when following the sun is switched on again
AUTO_TEMP="$RUNTIME/wlsunset-auto-temp"

if [ "$1" = toggle ]; then
	case "${SWAYNC_TOGGLE_STATE:-$([ -e "$DISABLED" ] && echo true || echo false)}" in
	true)
		if [ -e "$DISABLED" ]; then
			rm -f "$DISABLED"
			[ -e "$AUTO_TEMP" ] && mv "$AUTO_TEMP" "$TEMP"
		fi
		;;
	*)
		if [ ! -e "$DISABLED" ]; then
			# Fixed mode holds the night temperature all day: freeze it at what the screen
			# shows right now, otherwise switching off during the day jumps to full strength
			level=$("$SCRIPTS/wlsunset-get-temp.sh")
			cat "$TEMP" 2>/dev/null >"$AUTO_TEMP" || echo 2500 >"$AUTO_TEMP"
			if [ "$level" -eq 0 ]; then
				echo 6499 >"$TEMP"
			else
				echo $((6500 - level * 50)) >"$TEMP"
			fi
			mkdir -p "$(dirname "$DISABLED")" && touch "$DISABLED"
		fi
		;;
	esac

	pending="$RUNTIME/wlsunset-mode-pending"
	stamp=$(date +%s%N)
	echo "$stamp" >"$pending"
	(
		sleep 0.5
		[ "$(cat "$pending")" = "$stamp" ] || exit 0
		temp=$(cat "$TEMP" 2>/dev/null || echo 2500)
		# Following the sun with the night light at 0 would do nothing: fall back to the default
		if [ ! -e "$DISABLED" ] && [ "$temp" -eq 6499 ]; then
			echo 2500 >"$TEMP"
		fi
		systemctl --user reset-failed wlsunset
		systemctl --user restart wlsunset
	) >/dev/null 2>&1 &
	exit
elif [ "$1" = status ]; then
	[ -e "$DISABLED" ] && echo false || echo true
else
	echo "Usage: $0 toggle|status" >&2
	exit 1
fi
