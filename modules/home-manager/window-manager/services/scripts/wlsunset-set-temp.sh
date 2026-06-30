#!/usr/bin/env bash
temp="$1"
echo "$temp" >"${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wlsunset-night-temp"
systemctl --user restart wlsunset
