#!/bin/bash

# Auto Performance Installation Script
# This script helps set up the auto-performance service

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/auto-performance.sh"
SYSTEM_SERVICE_FILE="/etc/systemd/system/auto-performance@.service"
SYSTEM_SERVICE_TEMPLATE="$SCRIPT_DIR/auto-performance@.service"
USER_SERVICE_DIR="$HOME/.config/systemd/user"
USER_SERVICE_FILE="$USER_SERVICE_DIR/auto-performance.service"
USER_SERVICE_TEMPLATE="$SCRIPT_DIR/auto-performance.service"

# Basic installation function
basic_install() {
    echo "Auto Performance Basic Installation"
    echo "=================================="

    # Make the main script executable
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        echo "✓ Made auto-performance.sh executable"
    else
        echo "✗ Error: auto-performance.sh not found in $SCRIPT_DIR"
        return 1
    fi

    # Create symlink in PATH for easy access
    SYMLINK_PATH="/usr/local/bin/auto-performance"
    if [ -w "/usr/local/bin" ]; then
        if [ -L "$SYMLINK_PATH" ] || [ -f "$SYMLINK_PATH" ]; then
            rm -f "$SYMLINK_PATH"
        fi
        ln -s "$SCRIPT_PATH" "$SYMLINK_PATH"
        echo "✓ Created symlink: $SYMLINK_PATH -> $SCRIPT_PATH"
    else
        echo "! Note: Cannot create symlink in /usr/local/bin (no write permission)"
        echo "  You can run the script directly from: $SCRIPT_PATH"
    fi

    # Check for required dependencies
    echo ""
    echo "Checking dependencies:"

    if command -v powerprofilesctl >/dev/null 2>&1; then
        echo "✓ powerprofilesctl found"
    else
        echo "! powerprofilesctl not found (will use sysfs fallback)"
    fi

    if command -v notify-send >/dev/null 2>&1; then
        echo "✓ notify-send found"
    else
        echo "! notify-send not found (notifications disabled)"
    fi

    if command -v udevadm >/dev/null 2>&1; then
        echo "✓ udevadm found"
    else
        echo "! udevadm not found (will use polling method)"
    fi

    echo ""
    echo "Basic installation complete!"
    echo ""
    echo "Usage:"
    echo "  $SCRIPT_PATH start    # Start monitoring"
    echo "  $SCRIPT_PATH stop     # Stop monitoring"
    echo "  $SCRIPT_PATH status   # Check status"
    echo ""
    echo "To install as a systemd service, run:"
    echo "  $0 service"
}

# Function to install system-wide service
install_system_service() {
    echo "Installing system-wide service..."
    
    # Check if template exists
    if [ ! -f "$SYSTEM_SERVICE_TEMPLATE" ]; then
        echo "✗ Service template not found: $SYSTEM_SERVICE_TEMPLATE"
        return 1
    fi
    
    # Copy template to system location
    if sudo cp "$SYSTEM_SERVICE_TEMPLATE" "$SYSTEM_SERVICE_FILE"; then
        echo "✓ System service file created: $SYSTEM_SERVICE_FILE"
        
        # Reload systemd
        sudo systemctl daemon-reload
        
        # Enable and start for current user
        sudo systemctl enable "auto-performance@$USER.service"
        sudo systemctl start "auto-performance@$USER.service"
        
        echo "✓ Service enabled and started for user: $USER"
        echo ""
        echo "Service status:"
        sudo systemctl status "auto-performance@$USER.service" --no-pager -l
        
        return 0
    else
        echo "✗ Failed to create system service file"
        return 1
    fi
}

# Function to install user service
install_user_service() {
    echo "Installing user service..."
    
    # Check if template exists
    if [ ! -f "$USER_SERVICE_TEMPLATE" ]; then
        echo "✗ Service template not found: $USER_SERVICE_TEMPLATE"
        return 1
    fi
    
    # Create user service directory
    mkdir -p "$USER_SERVICE_DIR"
    
    # Copy template to user location
    if cp "$USER_SERVICE_TEMPLATE" "$USER_SERVICE_FILE"; then
        echo "✓ User service file created: $USER_SERVICE_FILE"
        
        # Reload user systemd
        systemctl --user daemon-reload
        
        # Enable and start service
        systemctl --user enable auto-performance.service
        systemctl --user start auto-performance.service
        
        echo "✓ User service enabled and started"
        echo ""
        echo "Service status:"
        systemctl --user status auto-performance.service --no-pager -l
        
        return 0
    else
        echo "✗ Failed to create user service file"
        return 1
    fi
}

# Function to uninstall services
uninstall_services() {
    echo "Uninstalling auto-performance services..."
    
    # Stop and disable system service
    if [ -f "$SYSTEM_SERVICE_FILE" ]; then
        sudo systemctl stop "auto-performance@$USER.service" 2>/dev/null || true
        sudo systemctl disable "auto-performance@$USER.service" 2>/dev/null || true
        sudo rm -f "$SYSTEM_SERVICE_FILE"
        sudo systemctl daemon-reload
        echo "✓ System service removed"
    fi
    
    # Stop and disable user service
    if [ -f "$USER_SERVICE_FILE" ]; then
        systemctl --user stop auto-performance.service 2>/dev/null || true
        systemctl --user disable auto-performance.service 2>/dev/null || true
        rm -f "$USER_SERVICE_FILE"
        systemctl --user daemon-reload
        echo "✓ User service removed"
    fi
    
    # Remove symlink if it exists
    SYMLINK_PATH="/usr/local/bin/auto-performance"
    if [ -L "$SYMLINK_PATH" ]; then
        sudo rm -f "$SYMLINK_PATH" 2>/dev/null || rm -f "$SYMLINK_PATH" 2>/dev/null || true
        echo "✓ Symlink removed"
    fi
    
    echo "✓ All services uninstalled"
}

# Function to show service files info
show_service_info() {
    echo "Service files information:"
    echo "========================="
    
    echo ""
    echo "System service template: $SYSTEM_SERVICE_TEMPLATE"
    if [ -f "$SYSTEM_SERVICE_TEMPLATE" ]; then
        echo "✓ Template exists"
    else
        echo "✗ Template missing"
    fi
    
    echo ""
    echo "User service template: $USER_SERVICE_TEMPLATE"
    if [ -f "$USER_SERVICE_TEMPLATE" ]; then
        echo "✓ Template exists"
    else
        echo "✗ Template missing"
    fi
    
    echo ""
    echo "Installed system service: $SYSTEM_SERVICE_FILE"
    if [ -f "$SYSTEM_SERVICE_FILE" ]; then
        echo "✓ Installed"
    else
        echo "✗ Not installed"
    fi
    
    echo ""
    echo "Installed user service: $USER_SERVICE_FILE"
    if [ -f "$USER_SERVICE_FILE" ]; then
        echo "✓ Installed"
    else
        echo "✗ Not installed"
    fi
}

# Function to show service status
show_service_status() {
    echo "System service status:"
    if [ -f "$SYSTEM_SERVICE_FILE" ]; then
        sudo systemctl status "auto-performance@$USER.service" --no-pager -l
    else
        echo "System service not installed"
    fi
    
    echo ""
    echo "User service status:"
    if [ -f "$USER_SERVICE_FILE" ]; then
        systemctl --user status auto-performance.service --no-pager -l
    else
        echo "User service not installed"
    fi
}

# Service installation menu
service_menu() {
    echo "Auto Performance Systemd Service Installer"
    echo "=========================================="
    echo ""
    echo "Choose installation type:"
    echo ""
    echo "1. System-wide service (recommended)"
    echo "   - Runs for specific user with root privileges"
    echo "   - Better integration with system boot"
    echo "   - Requires sudo access"
    echo ""
    echo "2. User service"
    echo "   - Runs in user session only"
    echo "   - No sudo required"
    echo "   - May not start on system boot"
    echo ""
    echo "3. Show service status"
    echo "4. Show service files info"
    echo "5. Uninstall all services"
    echo ""
    
    read -p "Choose option (1-5): " choice
    case "$choice" in
        1)
            install_system_service
            ;;
        2)
            install_user_service
            ;;
        3)
            show_service_status
            ;;
        4)
            show_service_info
            ;;
        5)
            uninstall_services
            ;;
        *)
            echo "Invalid choice"
            exit 1
            ;;
    esac
}

# Main menu
case "${1:-menu}" in
    "basic")
        basic_install
        ;;
    "service")
        service_menu
        ;;
    "system")
        basic_install && echo "" && install_system_service
        ;;
    "user")
        basic_install && echo "" && install_user_service
        ;;
    "uninstall")
        uninstall_services
        ;;
    "status")
        show_service_status
        ;;
    "info")
        show_service_info
        ;;
    *)
        echo "Auto Performance Installation Script"
        echo "===================================="
        echo ""
        echo "Choose installation type:"
        echo ""
        echo "1. Basic installation"
        echo "   - Makes script executable"
        echo "   - Creates symlink (if possible)"
        echo "   - Checks dependencies"
        echo ""
        echo "2. System-wide service (recommended)"
        echo "   - Includes basic installation"
        echo "   - Installs systemd service for all users"
        echo "   - Starts automatically on boot"
        echo ""
        echo "3. User service"
        echo "   - Includes basic installation"
        echo "   - Installs systemd service for current user"
        echo "   - Starts with user session"
        echo ""
        echo "4. Service management menu"
        echo "   - Install/uninstall services"
        echo "   - Check status and info"
        echo ""
        echo "Usage:"
        echo "  $0           - Show this menu"
        echo "  $0 basic     - Basic installation only"
        echo "  $0 system    - Basic + system service"
        echo "  $0 user      - Basic + user service"
        echo "  $0 service   - Service management menu"
        echo "  $0 status    - Show service status"
        echo "  $0 info      - Show service files info"
        echo "  $0 uninstall - Remove all services"
        echo ""
        
        read -p "Choose option (1-4): " choice
        case "$choice" in
            1)
                basic_install
                ;;
            2)
                basic_install && echo "" && install_system_service
                ;;
            3)
                basic_install && echo "" && install_user_service
                ;;
            4)
                service_menu
                ;;
            *)
                echo "Invalid choice"
                exit 1
                ;;
        esac
        ;;
esac
