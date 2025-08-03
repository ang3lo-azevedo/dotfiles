#!/usr/bin/env bash

# Simple wlsunset toggle for swaync

if pgrep wlsunset >/dev/null 2>&1; then
    # wlsunset is running, kill it
    pkill wlsunset
    notify-send "Night Light" "Disabled" --expire-time=2000
    echo "Desabilitado"
else
    # wlsunset is not running, start it with geolocation
    {
        CONTENT=$(curl -s http://ip-api.com/json/)
        if [ $? -eq 0 ]; then
            longitude=$(echo $CONTENT | jq -r .lon)
            latitude=$(echo $CONTENT | jq -r .lat)
            wlsunset -l $latitude -L $longitude >/dev/null 2>&1 &
        else
            # Fallback coordinates (Berlin)
            wlsunset -l 52.5 -L 13.4 >/dev/null 2>&1 &
        fi
    } &
    notify-send "Night Light" "Enabled" --expire-time=2000
    echo "Habilitado"
fi

# Sync waybar
pkill -RTMIN+1 waybar 2>/dev/null || true
