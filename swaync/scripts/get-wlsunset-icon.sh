#!/usr/bin/env bash

# Get wlsunset status icon for swaync - synced with waybar

# Check state file first, fallback to process check
if [[ -f "/tmp/wlsunset-state" ]]; then
    STATE=$(cat /tmp/wlsunset-state)
else
    if pgrep wlsunset >/dev/null 2>&1; then
        STATE="on"
    else
        STATE="off"
    fi
fi

if [[ "$STATE" == "on" ]]; then
    echo "󰖕"  # Moon icon (night light on)
else
    echo "󰖔"  # Sun icon (night light off)  
fi
