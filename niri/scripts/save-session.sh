#!/bin/bash

# Script to save current session state
SESSION_FILE="$HOME/.config/niri/session.txt"

# Create session file directory if it doesn't exist
mkdir -p "$(dirname "$SESSION_FILE")"

# Clear existing session file
true > "$SESSION_FILE"

echo "Saving current session..."

# Save current workspace to the session file first
CURRENT_WORKSPACE_LINE=$(niri msg workspaces | awk '/\*/')
CURRENT_WORKSPACE_ID=$(echo "$CURRENT_WORKSPACE_LINE" | awk '{print $2}')
CURRENT_WORKSPACE_NAME=$(echo "$CURRENT_WORKSPACE_LINE" | awk '{print $3}' | sed 's/"//g')

# Use workspace name if available, otherwise use ID
if [[ -n "$CURRENT_WORKSPACE_NAME" && "$CURRENT_WORKSPACE_NAME" != "" ]]; then
    CURRENT_WORKSPACE="$CURRENT_WORKSPACE_NAME"
else
    CURRENT_WORKSPACE="$CURRENT_WORKSPACE_ID"
fi

if [[ -n "$CURRENT_WORKSPACE" ]]; then
    echo "CURRENT_WORKSPACE:$CURRENT_WORKSPACE" >> "$SESSION_FILE"
    echo "Current workspace detected: $CURRENT_WORKSPACE"
fi

# Get all windows and their workspaces
# Parse the niri msg windows output to extract app_id and workspace
niri msg windows | awk '
/^Window ID/ { 
    window_id = $3
    gsub(/:$/, "", window_id)
}
/^  App ID:/ { 
    app_id = $3
    gsub(/^"/, "", app_id)
    gsub(/"$/, "", app_id)
}
/^  Workspace ID:/ { 
    workspace_id = $3
    if (app_id != "" && app_id != "null" && workspace_id != "") {
        print app_id ":" workspace_id
    }
    app_id = ""
    workspace_id = ""
}' | while IFS=':' read -r app_id workspace; do
    # Skip empty or invalid entries
    if [[ -n "$app_id" && "$app_id" != "null" && "$app_id" != "unknown" ]]; then
        echo "$app_id:$workspace" >> "$SESSION_FILE"
    fi
done

# Remove duplicates while preserving order
if [[ -f "$SESSION_FILE" ]]; then
    awk '!seen[$0]++' "$SESSION_FILE" > "${SESSION_FILE}.tmp" && mv "${SESSION_FILE}.tmp" "$SESSION_FILE"
fi

echo "Session saved to $SESSION_FILE"

# Show what was saved for debugging
if [[ -f "$SESSION_FILE" && -s "$SESSION_FILE" ]]; then
    echo "Saved session:"
    cat "$SESSION_FILE"
else
    echo "Warning: No session data was saved"
fi
