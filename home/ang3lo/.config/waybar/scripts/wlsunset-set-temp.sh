#!/usr/bin/env bash
# Usage: wlsunset-set-temp.sh <0-100>: night light strength, 0 turns it off
level="${1%.*}"
# Detent around the default strength: 60 is nightTemp (3500K) in wlsunset.nix,
# and the tick drawn on the slider in swaync/style.css
if [ "$level" -ge 57 ] && [ "$level" -le 63 ]; then
	level=60
fi
runtime="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
pending="$runtime/wlsunset-pending-level"
echo "$level" >"$pending"

# A drag fires this for every step: restarting each time trips systemd's start limit
# and leaves wlsunset dead, so only act once the slider has settled on this value
(
	sleep 0.5
	[ "$(cat "$pending")" = "$level" ] || exit 0
	if [ "$level" -eq 0 ]; then
		systemctl --user stop wlsunset
	else
		# 6500 is dayTemp in wlsunset.nix: wlsunset refuses a night temperature that is not below it
		echo $((6500 - level * 50)) >"$runtime/wlsunset-night-temp"
		systemctl --user reset-failed wlsunset
		systemctl --user restart wlsunset
	fi
) >/dev/null 2>&1 &
