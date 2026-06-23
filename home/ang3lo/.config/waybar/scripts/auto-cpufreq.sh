#!/usr/bin/env bash

# Read current governor from cpu0
GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)

if [ "$GOVERNOR" = "performance" ]; then
    TEXT="performance"
    ICON=""
    CLASS="performance"
elif [ "$GOVERNOR" = "powersave" ]; then
    TEXT="powersave"
    ICON=""
    CLASS="powersave"
elif [ "$GOVERNOR" = "schedutil" ] || [ "$GOVERNOR" = "ondemand" ]; then
    TEXT="balanced"
    ICON=""
    CLASS="balanced"
else
    TEXT="$GOVERNOR"
    ICON=""
    CLASS="unknown"
fi

# Print JSON for Waybar
echo "{\"text\": \"$ICON\", \"alt\": \"$TEXT\", \"tooltip\": \"CPU Governor: $TEXT\", \"class\": \"$CLASS\"}"
