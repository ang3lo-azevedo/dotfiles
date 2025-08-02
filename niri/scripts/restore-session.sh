#!/bin/bash

# Script to restore session from saved state
SESSION_FILE="$HOME/.config/niri/session.txt"

# Function to wait for niri to be ready
wait_for_niri() {
    local retries=0
    local max_retries=30
    
    while [ $retries -lt $max_retries ]; do
        if niri msg version >/dev/null 2>&1; then
            echo "Niri is ready"
            return 0
        fi
        sleep 1
        retries=$((retries + 1))
    done
    
    echo "Timeout waiting for Niri to be ready"
    return 1
}

# Function to launch application
launch_app() {
    local app_id="$1"
    local workspace_id="$2"
    
    # Convert workspace ID to workspace name if needed
    local workspace_name
    case "$workspace_id" in
        "1")
            workspace_name="other"
            ;;
        "2")
            workspace_name="browser"
            ;;
        "3")
            workspace_name="dev"
            ;;
        *)
            ;;
    esac

    # Custom handling for specific applications
    case "$app_id" in
        "Spotify")
            app_id="spotify"
            ;;
        "zen")
            app_id="zen-browser"
            ;;
        "com.mitchellh.ghostty")
            app_id="ghostty"
            ;;
        *)
            ;;
    esac

    local workspace_name="${workspace_name:-$workspace_id}"

    echo "Application: $app_id, trying to launch in workspace $workspace_name..."
    sleep 0.5
    "$app_id" &
    niri msg action focus-window "$app_id"
    niri msg action move-window-to-workspace "$workspace_name"
    
    # Small delay to prevent race conditions
    sleep 1
}

# Wait for Niri to be ready
wait_for_niri\

# Check if session file exists
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "No session file found at $SESSION_FILE"
    exit 0
fi

echo "Restoring session from $SESSION_FILE..."

# First pass: extract current workspace and applications
LAST_WORKSPACE=""
declare -a APPS_TO_RESTORE

while IFS=':' read -r key value; do
    if [[ "$key" == "CURRENT_WORKSPACE" ]]; then
        LAST_WORKSPACE="$value"
    elif [[ -n "$key" && -n "$value" && "$key" != "CURRENT_WORKSPACE" ]]; then
        APPS_TO_RESTORE+=("$key:$value")
    fi
done < "$SESSION_FILE"

# Restore applications
for app_entry in "${APPS_TO_RESTORE[@]}"; do
    IFS=':' read -r app_id workspace <<< "$app_entry"
    if [[ -n "$app_id" && -n "$workspace" ]]; then
        launch_app "$app_id" "$workspace"
    fi
done

echo "Session restoration completed"

# Focus on the last active workspace if saved
if [[ -n "$LAST_WORKSPACE" ]]; then
    echo "Focusing on last active workspace: $LAST_WORKSPACE"
    niri msg action focus-workspace "$LAST_WORKSPACE"
fi
