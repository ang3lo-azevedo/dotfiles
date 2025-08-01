#!/bin/bash

# Script to initialize applications in specific workspaces
# Waits for Niri to be fully loaded before opening applications

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

# Wait for Niri to be ready
wait_for_niri

# Wait a bit more to stabilize
sleep 2

# Open Spotify in workspace 1 (current)
echo "Opening Spotify in workspace 1..."
spotify &
sleep 1

# Go to workspace 2 and open browser
echo "Opening browser in workspace 2..."
niri msg action focus-workspace 2
sleep 0.5
zen-browser &
sleep 2

# Open VS Code in the same workspace (to the right of browser)
echo "Opening VS Code to the right of browser..."
code ~/.config &
sleep 1

# Return to workspace 1
echo "Returning to workspace 1..."
niri msg action focus-workspace 1

echo "Application initialization completed"
