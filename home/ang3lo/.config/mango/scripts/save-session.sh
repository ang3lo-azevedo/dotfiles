mkdir -p ~/.cache

# Try to get the list of windows
if WINDOWS=$(lswt -j 2>/dev/null); then
    # If lswt succeeded, parse and save
    echo "$WINDOWS" | jq -r '.[] | .app_id' | grep -vE "^(null|waybar|swaync|swaybg|wlsunset)$" | sort -u > ~/.cache/mango-session
else
    # If lswt failed (e.g. compositor already dead), do not overwrite the file
    echo "Could not connect to Wayland compositor. Session not saved." >&2
    exit 1
fi
