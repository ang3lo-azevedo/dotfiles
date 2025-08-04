#!/bin/bash

# Auto Performance Mode Manager for Niri
# This script monitors AC power status and automatically adjusts CPU governor

# Log file for debugging
LOG_FILE="$HOME/.config/auto-performance/auto-performance.log"
CACHE_FILE="$HOME/.cache/prev_power_profile.txt"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Ensure cache file exists
ensure_cache_file() {
    mkdir -p "$(dirname "$CACHE_FILE")"
    touch "$CACHE_FILE"
}

# Get current CPU governor
get_cpu_governor() {
    if command -v powerprofilesctl >/dev/null 2>&1; then
        powerprofilesctl get 2>/dev/null || echo "unknown"
    elif [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
        cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null
    else
        echo "unknown"
    fi
}

# Set CPU governor/power profile
set_cpu_governor() {
    local profile="$1"
    if [ -z "$profile" ]; then
        log_message "ERROR: No profile specified"
        return 1
    fi
    
    # Map old governor names to power profile names
    case "$profile" in
        "performance")
            profile="performance"
            ;;
        "powersave")
            profile="power-saver"
            ;;
        "balanced")
            profile="balanced"
            ;;
    esac
    
    # Get current profile
    local current_profile=""
    if command -v powerprofilesctl >/dev/null 2>&1; then
        current_profile=$(powerprofilesctl get 2>/dev/null)
    fi
    
    # Check cache to avoid duplicate notifications
    local prev_profile=""
    if [[ -f "$CACHE_FILE" ]]; then
        prev_profile=$(cat "$CACHE_FILE" 2>/dev/null)
    fi
    
    if [[ "$current_profile" == "$profile" && "$prev_profile" == "$profile" ]]; then
        log_message "INFO: Already on $profile profile, skipping"
        return 0
    fi
    
    # Try using powerprofilesctl first (modern approach)
    if command -v powerprofilesctl >/dev/null 2>&1; then
        if powerprofilesctl set "$profile" 2>/dev/null; then
            log_message "INFO: Power profile set to '$profile' using powerprofilesctl"
            
            # Update cache
            echo "$profile" > "$CACHE_FILE"
            
            # Only send notification if profile actually changed
            if [[ "$prev_profile" != "$profile" ]]; then
                # Send notification if we're in a desktop environment
                if [ -n "$DISPLAY" ] && command -v notify-send >/dev/null 2>&1; then
                    # Choose appropriate icon based on profile
                    local icon=""
                    case "$profile" in
                        "performance")
                            icon="battery-full-charging"
                            ;;
                        "power-saver")
                            icon="battery-low"
                            ;;
                        "balanced")
                            icon="battery-good"
                            ;;
                        *)
                            icon="power-profile"
                            ;;
                    esac
                    
                    notify-send -u normal -i "$icon" \
                        "Auto Performance" "Power profile: $profile" --expire-time=3000 2>/dev/null || true
                fi
            fi
            
            return 0
        else
            log_message "ERROR: Failed to set power profile to '$profile' using powerprofilesctl"
            return 1
        fi
    fi
    
    # Fallback to direct sysfs approach if powerprofilesctl is not available
    log_message "WARN: powerprofilesctl not available, falling back to sysfs"
    
    # Convert power profile back to governor for sysfs
    case "$profile" in
        "power-saver")
            profile="powersave"
            ;;
        "balanced")
            profile="schedutil"
            ;;
        "performance")
            profile="performance"
            ;;
    esac
    
    # Check if governor is available
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors ]; then
        if ! grep -q "$profile" /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors 2>/dev/null; then
            log_message "ERROR: Governor '$profile' not available"
            return 1
        fi
    fi
    
    # Set governor for all CPUs using pkexec
    local success=true
    for cpu_path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        if [ -f "$cpu_path" ]; then
            if ! echo "$profile" | pkexec tee "$cpu_path" >/dev/null 2>&1; then
                log_message "ERROR: Failed to set governor to '$profile' for $cpu_path"
                success=false
                break
            fi
        fi
    done
    
    if [ "$success" = true ]; then
        log_message "INFO: CPU governor successfully set to '$profile'"
        
        # Send notification if we're in a desktop environment
        if [ -n "$DISPLAY" ] && command -v notify-send >/dev/null 2>&1; then
            # Choose appropriate icon based on profile
            local icon=""
            case "$profile" in
                "performance")
                    icon="battery-full-charging"
                    ;;
                "powersave")
                    icon="battery-low"
                    ;;
                "schedutil")
                    icon="battery-good"
                    ;;
                *)
                    icon="power-profile"
                    ;;
            esac
            
            notify-send -i "$icon" "Auto Performance" "CPU governor set to '$profile'" --expire-time=2000
        fi
        
        return 0
    else
        log_message "ERROR: Failed to set governor to '$profile'"
        return 1
    fi
}

# Check if AC adapter is connected (charging)
check_ac_status() {
    # Check multiple possible AC adapter paths
    for ac_path in /sys/class/power_supply/A{C,DP}*; do
        if [ -d "$ac_path" ] && [ -f "$ac_path/online" ]; then
            if [ "$(cat "$ac_path/online" 2>/dev/null)" = "1" ]; then
                return 0  # AC connected
            fi
        fi
    done
    return 1  # AC not connected
}

# Monitor power status using udev events
monitor_with_udev() {
    log_message "INFO: Starting udev monitoring for power supply changes"
    
    # Set initial state
    if check_ac_status; then
        set_cpu_governor "performance"
    else
        set_cpu_governor "power-saver"
    fi
    
    # Monitor udev events for power supply changes
    udevadm monitor --udev --subsystem-match=power_supply | while read -r line; do
        if echo "$line" | grep -q "change.*power_supply"; then
            # Small delay to ensure the change is reflected in sysfs
            sleep 1
            
            if check_ac_status; then
                current_profile=$(get_cpu_governor)
                if [ "$current_profile" != "performance" ]; then
                    log_message "INFO: AC connected, switching to performance mode"
                    set_cpu_governor "performance"
                fi
            else
                current_profile=$(get_cpu_governor)
                if [ "$current_profile" = "performance" ]; then
                    log_message "INFO: AC disconnected, switching to power-saver mode"
                    set_cpu_governor "power-saver"
                fi
            fi
        fi
    done
}

# Monitor power status with polling (fallback)
monitor_with_polling() {
    log_message "INFO: Starting polling monitoring for power supply changes"
    
    local last_ac_status=""
    local current_ac_status=""
    
    # Set initial state
    if check_ac_status; then
        current_ac_status="connected"
        set_cpu_governor "performance"
    else
        current_ac_status="disconnected"
        set_cpu_governor "power-saver"
    fi
    last_ac_status="$current_ac_status"
    
    while true; do
        if check_ac_status; then
            current_ac_status="connected"
        else
            current_ac_status="disconnected"
        fi
        
        # Only change governor if AC status changed
        if [ "$current_ac_status" != "$last_ac_status" ]; then
            local current_profile
            current_profile=$(get_cpu_governor)
            
            if [ "$current_ac_status" = "connected" ]; then
                # AC connected - switch to performance
                if [ "$current_profile" != "performance" ]; then
                    log_message "INFO: AC connected, switching to performance mode"
                    set_cpu_governor "performance"
                fi
            else
                # AC disconnected - switch to power-saver
                if [ "$current_profile" = "performance" ]; then
                    log_message "INFO: AC disconnected, switching to power-saver mode"
                    set_cpu_governor "power-saver"
                fi
            fi
            
            last_ac_status="$current_ac_status"
        fi
        
        # Check every 3 seconds
        sleep 3
    done
}

# Create PID file to prevent multiple instances
PID_FILE="$HOME/.config/auto-performance/auto-performance.pid"

# Function to cleanup on exit
cleanup() {
    log_message "INFO: Auto-performance monitor stopped"
    rm -f "$PID_FILE"
    exit 0
}

# Set up signal handlers
trap cleanup EXIT INT TERM

# Handle script arguments
case "${1:-monitor}" in
    "start"|"monitor")
        # Check if already running
        if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            echo "Auto-performance monitor is already running (PID: $(cat "$PID_FILE"))"
            exit 1
        fi
        
        # Write PID file
        echo $$ > "$PID_FILE"
        
        echo "Starting auto-performance monitor..."
        log_message "INFO: Auto-performance monitor started (PID: $$)"
        
        # Initialize cache and set initial state
        ensure_cache_file
        
        # Set initial state based on current AC status
        if check_ac_status; then
            log_message "INFO: AC power detected on startup"
            set_cpu_governor "performance"
        else
            log_message "INFO: Battery power detected on startup"
            set_cpu_governor "balanced"
        fi
        
        # Try udev monitoring first, fallback to polling
        if command -v udevadm >/dev/null 2>&1; then
            monitor_with_udev
        else
            log_message "WARN: udevadm not available, using polling method"
            monitor_with_polling
        fi
        ;;
    "stop")
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            if kill "$PID" 2>/dev/null; then
                echo "Auto-performance monitor stopped (PID: $PID)"
                rm -f "$PID_FILE"
            else
                echo "Failed to stop auto-performance monitor"
                rm -f "$PID_FILE"  # Remove stale PID file
            fi
        else
            echo "Auto-performance monitor is not running"
        fi
        ;;
    "status")
        echo "AC Status: $(check_ac_status && echo "Connected" || echo "Disconnected")"
        echo "Power Profile: $(get_cpu_governor)"
        if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            echo "Auto-performance monitor: Running (PID: $(cat "$PID_FILE"))"
        else
            echo "Auto-performance monitor: Not running"
        fi
        ;;
    "performance")
        set_cpu_governor "performance"
        ;;
    "powersave"|"power-saver")
        set_cpu_governor "power-saver"
        ;;
    "balanced")
        set_cpu_governor "balanced"
        ;;
    "auto")
        if check_ac_status; then
            set_cpu_governor "performance"
        else
            set_cpu_governor "power-saver"
        fi
        ;;
    "log")
        if [ -f "$LOG_FILE" ]; then
            tail -n 20 "$LOG_FILE"
        else
            echo "No log file found"
        fi
        ;;
    *)
        echo "Usage: $0 [start|stop|status|performance|powersave|balanced|auto|log]"
        echo "  start      - Start monitoring AC status and auto-adjust power profile"
        echo "  stop       - Stop the monitoring service"
        echo "  status     - Display current AC, power profile, and service status"
        echo "  performance - Set performance power profile"
        echo "  powersave  - Set power-saver power profile"
        echo "  balanced   - Set balanced power profile"
        echo "  auto       - Set power profile based on current AC status"
        echo "  log        - Display recent log entries"
        exit 1
        ;;
esac
