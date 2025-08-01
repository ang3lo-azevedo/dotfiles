#!/bin/bash

# Script to check for system updates (Arch Linux)
# Returns JSON format for Waybar

# Function to check updates using different methods
check_updates() {
    local updates=0
    
    # Method 1: Try checkupdates if available
    if command -v checkupdates >/dev/null 2>&1; then
        updates=$(checkupdates 2>/dev/null | wc -l)
        if [ $? -eq 0 ]; then
            echo "$updates"
            return 0
        fi
    fi
    
    # Method 2: Try with pacman directly (requires sudo or root)
    if [ "$EUID" -eq 0 ]; then
        updates=$(pacman -Qu 2>/dev/null | wc -l)
        if [ $? -eq 0 ]; then
            echo "$updates"
            return 0
        fi
    fi
    
    # Method 3: Check if we can read pacman database and compare
    local db_date=$(stat -c %Y /var/lib/pacman/sync/*.db 2>/dev/null | sort -n | tail -1)
    local current_date=$(date +%s)
    local diff=$((current_date - db_date))
    
    # If database is older than 6 hours, suggest update check
    if [ $diff -gt 21600 ]; then
        echo "?"
        return 2
    fi
    
    # Default fallback
    echo "0"
    return 1
}

# Get number of updates
RESULT=$(check_updates)
EXIT_CODE=$?

# Format output based on result
case $EXIT_CODE in
    0)  # Successful check
        if [ "$RESULT" -gt 0 ]; then
            if [ "$RESULT" -eq 1 ]; then
                TOOLTIP="$RESULT update available"
            else
                TOOLTIP="$RESULT updates available"
            fi
            echo "{\"text\":\"$RESULT\",\"tooltip\":\"$TOOLTIP\",\"class\":\"has-updates\"}"
        else
            echo '{"text":"0","tooltip":"System is up to date","class":"updated"}'
        fi
        ;;
    1)  # Fallback method used
        echo '{"text":"0","tooltip":"System appears up to date (limited check)","class":"updated"}'
        ;;
    2)  # Database needs refresh
        echo '{"text":"?","tooltip":"Package database may be outdated. Click to refresh.","class":"error"}'
        ;;
    *)  # Error
        echo '{"text":"!","tooltip":"Unable to check for updates","class":"error"}'
        ;;
esac
