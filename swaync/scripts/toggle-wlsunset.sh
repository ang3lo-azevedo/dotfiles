#!/usr/bin/env bash

# Toggle wlsunset script for swaync

if pgrep wlsunset >/dev/null 2>&1; then
    # wlsunset is running, kill it
    pkill wlsunset
    notify-send "Night Light" "Disabled" --expire-time=2000
    echo "Night Light disabled"
else
    # wlsunset is not running, start it
    ~/.config/waybar/scripts/wlsunset.sh &
    notify-send "Night Light" "Enabled" --expire-time=2000
    echo "Night Light enabled"
fi
