#!/bin/bash

# Get current power profile for display
get_current_profile() {
    if command -v powerprofilesctl >/dev/null 2>&1; then
        current=$(powerprofilesctl get 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$current" ]; then
            case $current in
                "performance")
                    echo "\uf0e7  Performance (current)"
                    ;;
                "balanced")
                    echo "\uf24e   Balanced (current)"
                    ;;
                "power-saver")
                    echo "\uf240   Power Saver (current)"
                    ;;
                *)
                    echo "\uf0e7 $current (current)"
                    ;;
            esac
        else
            echo "\uf071 Not available"
        fi
    else
        echo "\uf071 Not available"
    fi
}

# Get current idle inhibitor status
get_idle_status() {
    # Check if idle inhibitor is active by looking for systemd-inhibit process
    if pgrep -f "systemd-inhibit.*idle" >/dev/null 2>&1; then
        echo " Disable Idle Inhibitor"
    else
        echo " Enable Idle Inhibitor"
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

SELECTION="$(printf "\uf011 Power Menu\n\uf1e6 Manage Power Profile\n%s" "$CURRENT_IDLE_STATUS" | fuzzel --dmenu -l 3 -p "> ")"

case $SELECTION in
	*"Power Menu"*)
		# Show system power submenu
		SYSTEM_SELECTION="$(printf "\uf023 Lock Screen\n\uf236 Suspend System\n\uf104 Log Out\n\uf2f1 Restart System\n\uf085 Restart to UEFI\n\uf071 Force Restart\n\uf011 Shutdown System" | fuzzel --dmenu -l 8 -p "> ")"
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
			"")
				# Handle ESC key press (empty selection)
				exec "$0"
				;;
		esac
		;;
	*"Power Profile"*)
		# Get current profile for display in submenu
		current=$(powerprofilesctl get 2>/dev/null)
		perf_indicator=""
		balanced_indicator=""
		saver_indicator=""
		
		case $current in
			"performance")
				perf_indicator=" (current)"
				;;
			"balanced")
				balanced_indicator=" (current)"
				;;
			"power-saver")
				saver_indicator=" (current)"
				;;
		esac
		
		# Show power profile submenu
		PROFILE_SELECTION="$(printf "\uf0e7 Performance Mode%s\n\uf24e Balanced Mode%s\n\uf240 Power Saver Mode%s" "$perf_indicator" "$balanced_indicator" "$saver_indicator" | fuzzel --dmenu -l 4 -p "> ")"
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
			"")
				# Handle ESC key press (empty selection)
				exec "$0"
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
	"")
		# Handle ESC key press (empty selection) - exit gracefully
		exit 0
		;;
esac