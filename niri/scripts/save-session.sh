#!/bin/bash

# Script to save current session state
SESSION_FILE="$HOME/.config/niri/session.txt"

# Create session file directory if it doesn't exist
mkdir -p "$(dirname "$SESSION_FILE")"

# Clear existing session file
true > "$SESSION_FILE"

echo "Saving current session..."

# Get focused window info and all windows with their workspaces
# Parse the niri msg windows output to extract app_id, workspace, and focus status
niri msg windows | awk '
/^Window ID/ { 
    window_id = $3
    gsub(/:$/, "", window_id)
    is_focused = ($0 ~ /\(focused\)/) ? "true" : "false"
}
/^  App ID:/ { 
    app_id = $3
    gsub(/^"/, "", app_id)
    gsub(/"$/, "", app_id)
}
/^  Workspace ID:/ { 
    workspace_id = $3
    if (app_id != "" && app_id != "null" && workspace_id != "") {
        if (is_focused == "true") {
            print "FOCUSED_APP:" app_id
        }
        print app_id ":" workspace_id
    }
    app_id = ""
    workspace_id = ""
    is_focused = ""
}' | while IFS=':' read -r key value; do
    # Handle focused app entry
    if [[ "$key" == "FOCUSED_APP" ]]; then
        echo "FOCUSED_APP:$value" >> "$SESSION_FILE"
        echo "Focused app detected: $value"
    # Skip empty or invalid entries for regular apps
    elif [[ -n "$key" && "$key" != "null" && "$key" != "unknown" && -n "$value" ]]; then
        echo "$key:$value" >> "$SESSION_FILE"
    fi
done

# Remove duplicates while preserving order and sort by workspace, then by preference
if [[ -f "$SESSION_FILE" ]]; then
    # Create temporary file with sorted content
    {
        # First, output focused app line if it exists
        grep "^FOCUSED_APP:" "$SESSION_FILE" || true
        
        # Then output applications sorted by workspace, with preferred order within each workspace
        grep -v "^FOCUSED_APP:" "$SESSION_FILE" | sort -t: -k2,2n -k1,1 | awk -F: '
        {
            # Define preference order for applications
            pref_order["Spotify"] = 1
            pref_order["code"] = 2
            pref_order["zen"] = 3
            pref_order["com.mitchellh.ghostty"] = 4
            
            # Default preference for unknown apps
            if (!(pref_order[$1])) pref_order[$1] = 99
            
            print pref_order[$1] ":" $0
        }' | sort -t: -k1,1n -k3,3n | cut -d: -f2-
    } > "${SESSION_FILE}.tmp" && mv "${SESSION_FILE}.tmp" "$SESSION_FILE"
fi

echo "Session saved to $SESSION_FILE"

# Show what was saved for debugging
if [[ -f "$SESSION_FILE" && -s "$SESSION_FILE" ]]; then
    echo "Saved session:"
    cat "$SESSION_FILE"
else
    echo "Warning: No session data was saved"
fi
