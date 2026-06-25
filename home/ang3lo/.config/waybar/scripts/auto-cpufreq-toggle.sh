#!/usr/bin/env sh

# Read current governor
GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)

if [ "$GOVERNOR" = "performance" ]; then
	# If performance, switch to powersave
	pkexec auto-cpufreq --force powersave
elif [ "$GOVERNOR" = "powersave" ]; then
	# If powersave, switch to auto/reset
	pkexec auto-cpufreq --force reset
else
	# If anything else (auto/balanced), switch to performance
	pkexec auto-cpufreq --force performance
fi
