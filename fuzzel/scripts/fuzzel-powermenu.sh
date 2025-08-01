#!/bin/bash

# Function to save session with error handling
save_session() {
    local action="$1"
    
    if [ -x ~/.config/niri/scripts/save-session.sh ]; then
        echo "Saving session before $action..."
        if ~/.config/niri/scripts/save-session.sh; then
            notify-send "Session Saved" "Current session saved before $action" --expire-time=2000
            sleep 0.5
            return 0
        else
            notify-send "Session Save Failed" "Could not save session before $action" --urgency=critical --expire-time=3000
            return 1
        fi
    else
        notify-send "Session Save Error" "Save session script not found or not executable" --urgency=critical --expire-time=3000
        return 1
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

# Get current values
CURRENT_IDLE_STATUS=$(get_idle_status)

# Main menu with power options and tools submenu
SELECTION="$(printf "\uf023 Lock Screen\n\uf236 Suspend System\n\uf104 Log Out\n\uf2f1 Restart System\n\uf085 Restart to UEFI\n\uf071 Force Restart\n\uf011 Shutdown System\n\uf085 Tools Menu" | fuzzel --dmenu -l 8 -p "> ")"

case $SELECTION in
	*"Lock Screen")
		swaylock;;
	*"Suspend System")
		systemctl suspend;;
	*"Log Out")
		save_session "logout"
		
		# Try Niri first, then fallback to other methods
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
		save_session "system restart"
		systemctl reboot;;
	*"Restart to UEFI")
		save_session "UEFI restart"
		systemctl reboot --firmware-setup;;
	*"Force Restart")
		save_session "force restart"
		pkexec "echo b > /proc/sysrq-trigger";;
	*"Shutdown System")
		save_session "shutdown"
		systemctl poweroff;;
	*"Tools Menu"*)
		# Show tools submenu
		TOOLS_SELECTION="$(printf "\uf1de Edit Niri Config\n\uf021 Restart Components\n%s" "$CURRENT_IDLE_STATUS" | fuzzel --dmenu -l 3 -p "> ")"
		case $TOOLS_SELECTION in
			*"Edit Niri Config"*)
				# Open Niri config.kdl in VS Code with dotfiles workspace
				code ~/.config ~/.config/niri/config.kdl
				;;
			*"Restart Components"*)
				# Show component restart submenu
				COMPONENT_SELECTION="$(printf "\uf0fe Restart Waybar\n\uf1d8 Restart Mako\n\uf186 Restart wlsunset\n\uf1b2 Restart All Components" | fuzzel --dmenu -l 5 -p "> ")"
				case $COMPONENT_SELECTION in
					*"Restart Waybar")
						pkill waybar
						sleep 0.5
						~/.config/waybar/scripts/start-waybar.sh
						notify-send "Component Restart" "Waybar restarted"
						;;
					*"Restart Mako")
						pkill mako
						sleep 0.5
						mako &
						notify-send "Component Restart" "Mako restarted"
						;;
					*"Restart wlsunset")
						pkill wlsunset
						sleep 0.5
						wlsunset &
						notify-send "Component Restart" "wlsunset restarted"
						;;
					*"Restart All Components")
						# Restart all main components
						pkill waybar mako wlsunset
						sleep 1
						waybar &
						mako &
						wlsunset &
						notify-send "Component Restart" "All components restarted"
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
				# Handle ESC key press (empty selection) - return to main menu
				exec "$0"
				;;
		esac
		;;
	"")
		# Handle ESC key press (empty selection) - exit gracefully
		exit 0
		;;
esac