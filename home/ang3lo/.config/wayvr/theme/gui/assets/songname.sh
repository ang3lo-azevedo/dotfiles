#!/bin/bash

# --- Process Check ---
if ! pgrep -x "wayvr" > /dev/null; then
    exit 1
fi
# ---------------------

wayvrctl panel-modify watch listenforsong set-visible 0

# Configuration
MAX_LENGTH=20
PADDING="    "
CHECK_INTERVAL=10  # Only check for song changes every N scroll steps

scroll_count=0
current_song=""

while :
do
    # Periodic check to ensure wayvr hasn't closed while the script was running
    if ! pgrep -x "wayvr" > /dev/null; then
        exit 0
    fi

    # Get the full title (with error handling)
    full_title="$(playerctl metadata title 2>/dev/null)"

    # If playerctl failed, wait and retry
    if [ -z "$full_title" ]; then
        sleep 1
        continue
    fi

    # Store current song for comparison
    current_song="$full_title"
    full_title="${full_title}${PADDING}"
    len=${#full_title}

    # If the title is short enough, just display it normally
    if [ "$len" -le "$MAX_LENGTH" ]; then
        echo "panel-modify watch songname set-text \"$full_title\"" | wayvrctl batch
        sleep 4
    else
        # Loop to scroll the text
        for (( i=0; i<len; i++ )); do
            # Extract a 20-character window starting at position i
            display_text="${full_title:$i:$MAX_LENGTH}"

            # If we reach the end of the string, wrap around to the beginning
            if [ ${#display_text} -lt $MAX_LENGTH ]; then
                suffix_len=$((MAX_LENGTH - ${#display_text}))
                display_text="${display_text}${full_title:0:$suffix_len}"
            fi

            echo "panel-modify watch songname set-text \"$display_text\"" | wayvrctl batch

            # Only check if song changed every CHECK_INTERVAL iterations
            scroll_count=$((scroll_count + 1))
            if [ $((scroll_count % CHECK_INTERVAL)) -eq 0 ]; then
                current_check="$(playerctl metadata title 2>/dev/null)"
                if [ -n "$current_check" ] && [ "$current_song" != "$current_check" ]; then
                    break # Break inner loop to update to the new song immediately
                fi
            fi

            sleep 1
        done
    fi
done
