#!/bin/bash

# Niri wrapper script that saves session on exit
CONFIG_DIR="$HOME/.config/niri"
SAVE_SESSION_SCRIPT="$CONFIG_DIR/scripts/save-session.sh"

# Function to save session on exit
cleanup() {
    echo "Niri is shutting down, saving session..."
    if [[ -x "$SAVE_SESSION_SCRIPT" ]]; then
        "$SAVE_SESSION_SCRIPT"
    else
        echo "Save session script not found or not executable"
    fi
}

# Set trap to save session on exit signals
trap cleanup EXIT INT TERM

# Start niri
exec niri "$@"
