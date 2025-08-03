#!/bin/bash

# Get current idle inhibitor status
get_idle_status() {
    # Check if idle inhibitor is active by looking for systemd-inhibit process
    if pgrep -f "systemd-inhibit.*idle" >/dev/null 2>&1; then
        echo " Disable Idle Inhibitor"
    else
        echo " Enable Idle Inhibitor"
    fi
}

# Check if Ventoy USB is connected
check_ventoy_usb() {
    # Quick check for Ventoy label
    if lsblk -f | grep -i "ventoy" >/dev/null 2>&1; then
        return 0
    fi
    
    # Check for USB devices that might be Ventoy
    # Look for USB storage devices with specific filesystems
    for device in /dev/sd[a-z]; do
        if [ -b "$device" ]; then
            # Check if it's a USB device
            if udevadm info --query=property --name="$device" 2>/dev/null | grep -q "ID_BUS=usb"; then
                # Check partitions for Ventoy indicators
                for part in "${device}"[0-9]*; do
                    if [ -b "$part" ]; then
                        # Try to mount and check for Ventoy directory
                        mount_point=$(mktemp -d 2>/dev/null) || continue
                        if mount "$part" "$mount_point" 2>/dev/null; then
                            if [ -d "$mount_point/ventoy" ] || [ -f "$mount_point/ventoy/ventoy.json" ]; then
                                umount "$mount_point" 2>/dev/null
                                rmdir "$mount_point" 2>/dev/null
                                return 0
                            fi
                            umount "$mount_point" 2>/dev/null
                        fi
                        rmdir "$mount_point" 2>/dev/null
                    fi
                done
            fi
        fi
    done
    
    return 1
}

# Get current values
CURRENT_IDLE_STATUS=$(get_idle_status)

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

# Build menu options dynamically
MENU_OPTIONS="\uf023 Lock Screen\n\uf236 Suspend System\n\uf104 Log Out\n\uf2f1 Restart System\n\uf085 Restart to UEFI"

# Add Ventoy option if USB is connected
if check_ventoy_usb; then
    MENU_OPTIONS="$MENU_OPTIONS\n\uf287 Restart to Ventoy"
fi

MENU_OPTIONS="$MENU_OPTIONS\n\uf071 Force Restart\n\uf011 Shutdown System\n\uf085 Tools Menu"

# Count menu items for fuzzel -l parameter
MENU_COUNT=$(echo -e "$MENU_OPTIONS" | wc -l)

# Main menu with power options and tools submenu
SELECTION="$(printf "$MENU_OPTIONS" | fuzzel --dmenu -l "$MENU_COUNT" -p "> ")"

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
	*"Restart to Ventoy")
		save_session "Ventoy restart"
		# Find Ventoy USB device and set it as next boot device
		ventoy_device=""
		
		# First try to find device by label
		ventoy_device=$(lsblk -o NAME,LABEL | grep -i ventoy | head -1 | awk '{print "/dev/" $1}' | sed 's/[0-9]*$//')
		
		# If not found by label, search manually
		if [ -z "$ventoy_device" ]; then
			for device in /dev/sd[a-z]; do
				if [ -b "$device" ]; then
					# Check if it's a USB device
					if udevadm info --query=property --name="$device" 2>/dev/null | grep -q "ID_BUS=usb"; then
						# Check partitions for Ventoy indicators
						for part in "${device}"[0-9]*; do
							if [ -b "$part" ]; then
								mount_point=$(mktemp -d 2>/dev/null) || continue
								if mount "$part" "$mount_point" 2>/dev/null; then
									if [ -d "$mount_point/ventoy" ] || [ -f "$mount_point/ventoy/ventoy.json" ]; then
										ventoy_device="$device"
										umount "$mount_point" 2>/dev/null
										rmdir "$mount_point" 2>/dev/null
										break 2
									fi
									umount "$mount_point" 2>/dev/null
								fi
								rmdir "$mount_point" 2>/dev/null
							fi
						done
					fi
				fi
			done
		fi
		
		if [ -n "$ventoy_device" ]; then
			# Use efibootmgr to set Ventoy as next boot device
			if command -v efibootmgr >/dev/null 2>&1; then
				# Try to find existing Ventoy boot entry
				ventoy_entry=$(efibootmgr | grep -i ventoy | head -1 | cut -c5-8)
				if [ -n "$ventoy_entry" ]; then
					pkexec efibootmgr -n "$ventoy_entry"
					notify-send "Ventoy Boot" "Set to boot from Ventoy on next restart"
				else
					notify-send "Ventoy Boot" "Ventoy boot entry not found in UEFI, creating temporary boot..."
					# Create a one-time boot entry for the USB device
					pkexec efibootmgr -c -d "$ventoy_device" -p 1 -L "Ventoy (Temp)" -l "\\EFI\\BOOT\\BOOTX64.EFI"
				fi
			else
				notify-send "Ventoy Boot" "efibootmgr not available, rebooting normally..."
			fi
			systemctl reboot
		else
			notify-send "Ventoy Error" "Could not find Ventoy USB device" --urgency=critical
		fi
		;;
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