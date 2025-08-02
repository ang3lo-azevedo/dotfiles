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
    local app_path="$app_id"

    # Custom handling for specific applications
    case "$app_id" in
        "Spotify")
            app_path="spotify"
            ;;
        "zen")
            app_path="zen-browser"
            ;;
        "com.mitchellh.ghostty")
            app_path="ghostty"
            ;;
        "code")
            # VS Code in workspace 1 opens with .config folder (the "other" workspace)
            # VS Code in other workspaces opens without arguments to restore previous state
            if [[ "$workspace_id" == "1" ]]; then
                app_path="code ~/.config"
            else
                app_path="code"
            fi
            ;;
        *)
            ;;
    esac

    echo "Launching application: $app_id in workspace $workspace_id..."
    
    # First, switch to the target workspace
    niri msg action focus-workspace "$workspace_id"
    sleep 0.5
    
    # Launch the application (use eval to handle commands with arguments)
    eval "$app_path" &
    local app_pid=$!
    
    # Wait a bit for the application to start
    sleep 2
    
    # Ensure the window is in the correct workspace
    niri msg action move-window-to-workspace "$workspace_id"
    
    echo "Launched $app_id (PID: $app_pid) in workspace $workspace_id"
}

# Wait for Niri to be ready
wait_for_niri\

# Check if session file exists
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "No session file found at $SESSION_FILE"
    exit 0
fi

echo "Restoring session from $SESSION_FILE..."

# First pass: extract focused app and applications
FOCUSED_APP=""
declare -a APPS_TO_RESTORE

while IFS=':' read -r key value; do
    if [[ "$key" == "FOCUSED_APP" ]]; then
        FOCUSED_APP="$value"
    elif [[ -n "$key" && -n "$value" && "$key" != "FOCUSED_APP" && "$key" != "CURRENT_WORKSPACE" ]]; then
        # Only add valid application entries (skip system entries)
        APPS_TO_RESTORE+=("$key:$value")
    fi
done < "$SESSION_FILE"

echo "Found ${#APPS_TO_RESTORE[@]} applications to restore"
if [[ -n "$FOCUSED_APP" ]]; then
    echo "Will focus on: $FOCUSED_APP"
fi

# Restore applications
for app_entry in "${APPS_TO_RESTORE[@]}"; do
    IFS=':' read -r app_id workspace <<< "$app_entry"
    if [[ -n "$app_id" && -n "$workspace" ]]; then
        launch_app "$app_id" "$workspace"
    fi
done

echo "Session restoration completed"

# Focus on the specific app that was focused if saved
if [[ -n "$FOCUSED_APP" ]]; then
    echo "Waiting for applications to fully load..."
    sleep 3
    echo "Focusing on last focused application: $FOCUSED_APP"
    
    # Try multiple approaches to focus the application
    if ! niri msg action focus-window --app-id "$FOCUSED_APP" 2>/dev/null; then
        echo "Fallback: trying alternative focus method..."
        niri msg action focus-window "$FOCUSED_APP" 2>/dev/null || true
    fi
else
    echo "No focused application to restore"
fi
