# Auto Performance

Automatic power profile manager that monitors AC adapter status and automatically adjusts CPU governor.

## Features

- **Automatic monitoring**: Detects when AC adapter is connected/disconnected
- **Smart profiles**: 
  - AC connected → Performance
  - Battery → Power-saver
  - Manual mode available
- **Notifications**: Shows profile changes via notify-send
- **Multiple methods**: Uses powerprofilesctl (modern) or sysfs (fallback)
- **Efficient monitoring**: udev events (preferred) or polling (fallback)

## Installation

### Basic Installation
```bash
cd ~/.config/auto-performance
chmod +x install.sh
./install.sh
```

### Systemd Service Installation (Recommended)

#### Quick Installation
```bash
cd ~/.config/auto-performance
./install.sh system    # System-wide service (recommended)
# or
./install.sh user      # User service
```

#### Manual Installation

1. **Create service file:**
```bash
sudo tee /etc/systemd/system/auto-performance@.service > /dev/null << 'EOF'
[Unit]
Description=Auto Performance Manager
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
User=%i
Environment=DISPLAY=:0
ExecStart=/home/%i/.config/auto-performance/auto-performance.sh start
ExecStop=/home/%i/.config/auto-performance/auto-performance.sh stop
Restart=always
RestartSec=5
KillMode=process

[Install]
WantedBy=default.target
EOF
```

2. **Enable and start the service:**
```bash
# For current user
sudo systemctl enable auto-performance@$USER.service
sudo systemctl start auto-performance@$USER.service

# Check status
sudo systemctl status auto-performance@$USER.service
```

3. **Service management:**
```bash
# Stop service
sudo systemctl stop auto-performance@$USER.service

# Restart service
sudo systemctl restart auto-performance@$USER.service

# Disable service
sudo systemctl disable auto-performance@$USER.service

# View service logs
sudo journalctl -u auto-performance@$USER.service -f
```

## Usage

### Basic Commands

```bash
# Start automatic monitoring
./auto-performance.sh start

# Stop monitoring
./auto-performance.sh stop

# Check status
./auto-performance.sh status

# View recent logs
./auto-performance.sh log
```

### Manual Profiles

```bash
# Set profile manually
./auto-performance.sh performance
./auto-performance.sh balanced
./auto-performance.sh power-saver

# Set based on current AC status
./auto-performance.sh auto
```

## Files

- `auto-performance.sh` - Main script
- `install.sh` - Complete installation script (basic + systemd service)
- `auto-performance@.service` - System-wide service template
- `auto-performance.service` - User service template
- `auto-performance.log` - Log file
- `auto-performance.pid` - PID file (when running)
- `~/.cache/prev_power_profile.txt` - Previous profile cache

## Autostart Options

### Option 1: Desktop Environment Autostart
Add to your desktop environment's autostart applications:
**Command:** `~/.config/auto-performance/auto-performance.sh start`

### Option 2: Systemd User Service (Alternative)
```bash
# Create user service directory
mkdir -p ~/.config/systemd/user

# Create user service file
tee ~/.config/systemd/user/auto-performance.service > /dev/null << 'EOF'
[Unit]
Description=Auto Performance Manager
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
Environment=DISPLAY=:0
ExecStart=%h/.config/auto-performance/auto-performance.sh start
ExecStop=%h/.config/auto-performance/auto-performance.sh stop
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF

# Enable and start user service
systemctl --user enable auto-performance.service
systemctl --user start auto-performance.service

# Check status
systemctl --user status auto-performance.service
```

## Dependencies

- **powerprofilesctl** (recommended) or sysfs access
- **notify-send** (optional, for notifications)
- **udevadm** (optional, for efficient monitoring)
- **pkexec** (if using sysfs fallback)

## Troubleshooting

### Check if it's working
```bash
./auto-performance.sh status
```

### View logs
```bash
./auto-performance.sh log
# or
tail -f ~/.config/auto-performance/auto-performance.log
```

### Test manual changes
```bash
# Disconnect AC and test
./auto-performance.sh power-saver

# Connect AC and test  
./auto-performance.sh performance
```

### Common Issues

1. **Service won't start**: Check permissions and paths
2. **No notifications**: Install `libnotify` package
3. **Profile changes don't work**: Ensure `power-profiles-daemon` is running
4. **High CPU usage**: Check if udev monitoring is working properly

### Debug Service Issues
```bash
# Check service logs
sudo journalctl -u auto-performance@$USER.service -f

# Check if service is running
sudo systemctl is-active auto-performance@$USER.service

# Restart service
sudo systemctl restart auto-performance@$USER.service
```

## Service Management Script

The `install.sh` script provides complete installation and service management:

```bash
# Interactive installation menu
./install.sh

# Basic installation only
./install.sh basic

# Install system-wide service (recommended)
./install.sh system

# Install user service
./install.sh user

# Service management menu
./install.sh service

# Check service status
./install.sh status

# Show service files information
./install.sh info

# Uninstall all services
./install.sh uninstall
```
