#!/bin/bash

# Start swaync with hot-reload (similar to start-waybar.sh)
swaync &
trap "killall swaync" EXIT
while inotifywait -q -e modify,moved_to ~/.config/swaync/config.json ~/.config/swaync/style.css 2>/dev/null; do
    swaync-client --reload-config >/dev/null 2>&1
    swaync-client --reload-css >/dev/null 2>&1
done
