#!/usr/bin/env bash

# Initialize wlsunset state synchronization

# Source sync functions
source ~/.config/swaync/scripts/wlsunset-sync.sh

# Update initial state
update_state_file

# Sync both interfaces
sync_waybar
sync_swaync

echo "Wlsunset sync initialized"
