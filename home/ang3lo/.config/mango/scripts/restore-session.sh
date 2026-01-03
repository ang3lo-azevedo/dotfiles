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
            nohup "$CMD" >/dev/null 2>&1 &
            sleep 0.5
        fi
    done < "$SESSION_FILE"
fi
