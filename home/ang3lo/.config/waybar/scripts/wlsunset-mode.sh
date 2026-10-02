#!/usr/bin/env bash
DISABLED="${XDG_STATE_HOME:-$HOME/.local/state}/wlsunset-auto-disabled"

if [ "$1" = toggle ]; then
	case "${SWAYNC_TOGGLE_STATE:-$([ -e "$DISABLED" ] && echo true || echo false)}" in
	true) rm -f "$DISABLED" ;;
	*) mkdir -p "$(dirname "$DISABLED")" && touch "$DISABLED" ;;
	esac

	pending="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wlsunset-mode-pending"
	stamp=$(date +%s%N)
	echo "$stamp" >"$pending"
	(
		sleep 0.5
		[ "$(cat "$pending")" = "$stamp" ] || exit 0
		was_active=$(systemctl --user is-active wlsunset)
		systemctl --user reset-failed wlsunset
		if [ "$was_active" = active ] || [ "$was_active" = failed ]; then
			systemctl --user restart wlsunset
		fi
	) >/dev/null 2>&1 &
	exit
elif [ "$1" = status ]; then
	[ -e "$DISABLED" ] && echo false || echo true
else
	echo "Usage: $0 toggle|status" >&2
	exit 1
fi
