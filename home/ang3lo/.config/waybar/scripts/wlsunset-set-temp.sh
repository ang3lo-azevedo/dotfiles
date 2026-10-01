#!/usr/bin/env bash
temp="$1"
state="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wlsunset-night-temp"
echo "$temp" >"$state"

# A drag fires this for every step: restarting each time trips systemd's start limit
# and leaves wlsunset dead, so only restart once the slider has settled on this value
(
	sleep 0.5
	if [ "$(cat "$state")" = "$temp" ]; then
		systemctl --user reset-failed wlsunset
		systemctl --user restart wlsunset
	fi
) >/dev/null 2>&1 &
