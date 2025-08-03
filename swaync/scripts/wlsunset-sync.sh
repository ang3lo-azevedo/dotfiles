#!/usr/bin/env bash

# Shared wlsunset state management
WLSUNSET_STATE_FILE="/tmp/wlsunset-state"

get_wlsunset_state() {
    if pgrep wlsunset >/dev/null 2>&1; then
        echo "on"
    else
        echo "off"
    fi
}

update_state_file() {
    get_wlsunset_state > "$WLSUNSET_STATE_FILE"
}

get_swaync_icon() {
    if [[ "$(get_wlsunset_state)" == "on" ]]; then
        echo "󰖕"  # Moon icon (night light on)
    else
        echo "󰖔"  # Sun icon (night light off)
    fi
}

sync_waybar() {
    pkill -RTMIN+1 waybar 2>/dev/null || true
}

sync_swaync() {
    # Update swaync button icon by reloading config
    swaync-client --reload-config >/dev/null 2>&1 || true
}
