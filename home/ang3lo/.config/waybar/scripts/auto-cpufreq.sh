#!/usr/bin/env sh

GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)

if [ "$GOVERNOR" = "performance" ]; then
	ALT="performance"
	CLASS="performance"
elif [ "$GOVERNOR" = "powersave" ]; then
	ALT="powersave"
	CLASS="powersave"
elif [ "$GOVERNOR" = "schedutil" ] || [ "$GOVERNOR" = "ondemand" ]; then
	ALT="balanced"
	CLASS="balanced"
else
	ALT="$GOVERNOR"
	CLASS="unknown"
fi

echo "{\"text\": \"\", \"alt\": \"$ALT\", \"tooltip\": \"CPU Governor: $ALT\", \"class\": \"$CLASS\"}"
