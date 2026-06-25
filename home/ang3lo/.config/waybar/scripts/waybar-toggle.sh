#!/usr/bin/env bash
exec 200>/tmp/waybar_toggle_script.lock
flock 200

LAST_RUN_FILE="/tmp/waybar_toggle_last_run"
NOW=$(date +%s%3N)

if [ -f "$LAST_RUN_FILE" ]; then
	LAST_RUN=$(cat "$LAST_RUN_FILE")
else
	LAST_RUN=0
fi

echo "$NOW" >"$LAST_RUN_FILE"

DIFF=$((NOW - LAST_RUN))

if [ "$DIFF" -gt 200 ]; then
	case "$1" in
	eDP-1)
		systemctl --user kill -s SIGUSR1 --kill-who=main waybar.service
		;;
	*)
		systemctl --user kill -s SIGUSR1 --kill-who=main "waybar-output@${1}.service"
		;;
	esac
fi
