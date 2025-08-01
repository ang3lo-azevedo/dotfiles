#!/bin/bash

# Get current power profile for display
get_current_profile() {
    if command -v powerprofilesctl >/dev/null 2>&1; then
        current=$(powerprofilesctl get 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$current" ]; then
            case $current in
                "performance")
                    echo "Performance (current)"
                    ;;
                "balanced")
                    echo "Balanced (current)"
                    ;;
                "power-saver")
                    echo "Power Saver (current)"
                    ;;
                *)
                    echo "$current (current)"
                    ;;
            esac
        else
            echo "Not available"
        fi
    else
        echo "Not available"
    fi
}

# Get current idle inhibitor status
get_idle_status() {
    # Check if idle inhibitor is active by looking for systemd-inhibit process
    if pgrep -f "systemd-inhibit.*idle" >/dev/null 2>&1; then
        echo "Disable Idle Inhibitor"
    else
        echo "Enable Idle Inhibitor"
    fi
}

# Function to set power profile with error handling
set_power_profile() {
    local profile=$1
    if command -v powerprofilesctl >/dev/null 2>&1; then
        # Execute the command and capture the exit code
        powerprofilesctl set "$profile" 2>/dev/null
        local exit_code=$?
        
        if [ $exit_code -eq 0 ]; then
            # Verify the change was applied
            local new_profile=$(powerprofilesctl get 2>/dev/null)
            if [ "$new_profile" = "$profile" ]; then
                notify-send "Power Profile" "Successfully switched to $profile mode"
            else
                notify-send "Power Profile" "Failed to switch to $profile mode (current: $new_profile)"
            fi
        else
            notify-send "Power Profile" "Failed to switch to $profile mode (exit code: $exit_code)"
        fi
    else
        notify-send "Power Profile" "powerprofilesctl not available"
    fi
}

# Get current values
CURRENT_PROFILE=$(get_current_profile)
CURRENT_IDLE_STATUS=$(get_idle_status)

SELECTION="$(printf "1 - System Power Menu\n2 - Power Profile: %s\n3 - %s" "$CURRENT_PROFILE" "$CURRENT_IDLE_STATUS" | fuzzel --dmenu -l 3 -p "Main Menu: ")"

case $SELECTION in
	*"System Power Menu")
		# Show system power submenu
		SYSTEM_SELECTION="$(printf "1 - Lock Screen\n2 - Suspend System\n3 - Log Out\n4 - Restart System\n5 - Restart to UEFI\n6 - Force Restart\n7 - Shutdown System" | fuzzel --dmenu -l 7 -p "System Power Menu: ")"
		case $SYSTEM_SELECTION in
			*"Lock Screen")
				swaylock;;
			*"Suspend System")
				systemctl suspend;;
			*"Log Out")
				# Try Niri first with correct syntax, then fallback to other methods
				if command -v niri >/dev/null 2>&1 && pgrep -f "niri --session" >/dev/null 2>&1; then
					niri msg action quit
				elif [ -n "$XDG_SESSION_ID" ]; then
					loginctl terminate-session "$XDG_SESSION_ID"
				else
					# Fallback to killing the session
					loginctl terminate-user "$USER"
				fi
				;;
			*"Restart System")
				systemctl reboot;;
			*"Restart to UEFI")
				systemctl reboot --firmware-setup;;
			*"Force Restart")
				pkexec "echo b > /proc/sysrq-trigger";;
			*"Shutdown System")
				systemctl poweroff;;
		esac
		;;
	*"Power Profile"*)
		# Show power profile submenu
		PROFILE_SELECTION="$(printf "1 - Performance Mode\n2 - Balanced Mode\n3 - Power Saver Mode" | fuzzel --dmenu -l 3 -p "Power Profile: ")"
		case $PROFILE_SELECTION in
			*"Performance Mode")
				set_power_profile "performance"
				;;
			*"Balanced Mode")
				set_power_profile "balanced"
				;;
			*"Power Saver Mode")
				set_power_profile "power-saver"
				;;
		esac
		;;
	*"Enable Idle Inhibitor")
		# Start idle inhibitor to prevent system from going idle/suspend
		if command -v systemd-inhibit >/dev/null 2>&1; then
			# Start a background process that inhibits idle and sleep
			systemd-inhibit --what=idle:sleep --who="fuzzel-powermenu" --why="User requested idle inhibitor" sleep infinity &
			notify-send "Idle Inhibitor" "Enabled - System will not idle or suspend"
		else
			notify-send "Idle Inhibitor" "systemd-inhibit not available"
		fi
		;;
	*"Disable Idle Inhibitor")
		# Stop idle inhibitor
		pkill -f "systemd-inhibit.*idle"
		notify-send "Idle Inhibitor" "Disabled - Normal power management restored"
		;;
esac