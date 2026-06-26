#!/usr/bin/env sh
SESSION_FILE=~/.cache/mango-session

if [ -f "$SESSION_FILE" ]; then
	while IFS= read -r app_id; do
		CMD="$app_id"
		case "$app_id" in
		"com.mitchellh.ghostty") CMD="ghostty" ;;
		"org.mozilla.firefox") CMD="firefox" ;;
		"Code") CMD="code" ;;
		"Spotify") CMD="spotify" ;;
		esac

		if command -v "$CMD" >/dev/null 2>&1; then
			# nohup detaches the process from this shell; sleep 0.5 staggers launches
			# so apps do not all race for the compositor and GPU at the same time
			nohup "$CMD" >/dev/null 2>&1 &
			sleep 0.5
		fi
	done <"$SESSION_FILE"
fi
