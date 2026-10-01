#!/usr/bin/env bash
# Night light strength as 0-100, 0 when wlsunset is off
if ! systemctl --user is-active --quiet wlsunset; then
	echo 0
	exit
fi
temp=$(cat "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wlsunset-night-temp" 2>/dev/null || echo 2500)
echo $(((6500 - temp + 25) / 50))
