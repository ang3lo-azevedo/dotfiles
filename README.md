# Dotfiles

[![CachyOS](https://img.shields.io/badge/OS-CachyOS-blue?style=flat-square&logo=archlinux)](https://cachyos.org/)
[![Niri](https://img.shields.io/badge/WM-Niri-purple?style=flat-square)](https://github.com/YaLTeR/niri)
[![Wayland](https://img.shields.io/badge/Display-Wayland-green?style=flat-square)](https://wayland.freedesktop.org/)
[![zsh](https://img.shields.io/badge/Shell-zsh-orange?style=flat-square&logo=gnu-bash)](https://www.zsh.org/)

My personal Linux system configurations for CachyOS with Niri as window manager.

![Screenshot](https://github.com/user-attachments/assets/1ef97088-009f-4057-b50d-f780c1e17055)

![Screenshot](https://github.com/user-attachments/assets/9b720767-7de0-4e10-82cf-917bbb908fd3)

![Screenshot](https://github.com/user-attachments/assets/8534ea57-1427-497e-be2d-31c415e97bf2)

## Setup Summary

Simple and efficient setup using **CachyOS** (Arch-based with performance optimizations) with **Wayland** and **Niri** as a rolling window manager. Minimal color usage, direct and effective workflow with **Fuzzel** handling most menu interactions for a streamlined development environment.

## System

| Component | Choice | Link |
|-----------|--------|------|
| **OS** | CachyOS | [GitHub](https://github.com/CachyOS/linux-cachyos) |
| **Bootloader** | rEFInd | [SourceForge](https://www.rodsbooks.com/refind/) |
| **Window Manager** | Niri | [GitHub](https://github.com/YaLTeR/niri) |
| **Shell** | zsh | [GitHub](https://github.com/zsh-users/zsh) |

## Theming

| Component | Theme | Description |
|-----------|-------|-------------|
| **GTK Applications** | Adwaita Dark | Default GNOME dark theme for GTK apps |
| **Qt Applications** | Adwaita Dark | Qt applications follow GTK theme via qt5ct |
| **Cursor Theme** | Adwaita | Consistent cursor appearance across all apps |
| **Color Scheme** | Dark Mode | System-wide dark theme preference |

## Window Manager Components

| Component | Description | Link |
|-----------|-------------|------|
| **[Niri](https://github.com/YaLTeR/niri)** | Window manager and compositor | [GitHub](https://github.com/YaLTeR/niri) |
| **[Waybar](https://github.com/Alexays/Waybar)** | Status bar | [GitHub](https://github.com/Alexays/Waybar) |
| **[Fuzzel](https://codeberg.org/dnkl/fuzzel)** | Application launcher | [Codeberg](https://codeberg.org/dnkl/fuzzel) |
| **[Swaync](https://github.com/ErikReider/SwayNotificationCenter)** | Notification center with widgets | [GitHub](https://github.com/ErikReider/SwayNotificationCenter) |
| **[Swaylock](https://github.com/swaywm/swaylock)** | Lock screen | [GitHub](https://github.com/swaywm/swaylock) |
| **[xwayland-satellite](https://github.com/Supreeeme/xwayland-satellite)** | XWayland support for Niri | [GitHub](https://github.com/Supreeeme/xwayland-satellite) |
| **[polkit-mate](https://github.com/mate-desktop/mate-polkit)** | Authentication agent | [GitHub](https://github.com/mate-desktop/mate-polkit) |
| **[swaybg](https://github.com/swaywm/swaybg)** | Background wallpaper | [GitHub](https://github.com/swaywm/swaybg) |
| **[swayidle](https://github.com/swaywm/swayidle)** | Idle management daemon | [GitHub](https://github.com/swaywm/swayidle) |
| **[wlsunset](https://gitlab.com/chinstrap/wlsunset)** | Automatic screen temperature adjustment | [GitLab](https://gitlab.com/chinstrap/wlsunset) |
| **[cliphist](https://github.com/sentriz/cliphist)** | Clipboard history | [GitHub](https://github.com/sentriz/cliphist) |
| **[bzmenu](https://github.com/e-tho/bzmenu)** | Bluetooth device menu | [GitHub](https://github.com/e-tho/bzmenu) |
| **[iwmenu](https://github.com/e-tho/iwmenu)** | Network interface menu | [GitHub](https://github.com/e-tho/iwmenu) |
| **[syshud](https://github.com/System64fumo/syshud)** | System HUD overlay | [GitHub](https://github.com/System64fumo/syshud) |

## Performance & System Management

| Component | Description | Link |
|-----------|-------------|------|
| **[auto-performance](auto-performance/)** | Automatic power profile manager | Local |

## Menu System & Interface

The system utilizes **Fuzzel** as the primary menu interface for most system interactions, providing a consistent and efficient workflow:

### Fuzzel Menu Integration
| Menu Type | Description | Trigger |
|-----------|-------------|---------|
| **Application Launcher** | Standard app launcher with fuzzel | Super key or waybar click |
| **Power Menu** | System power options with tools | `fuzzel-powermenu.sh` |
| **Tools Menu** | Integrated system tools and utilities | Within power menu |
| **Bluetooth Menu** | Device connection via bzmenu | Waybar bluetooth widget |
| **Network Menu** | WiFi management via iwmenu | Waybar network widget |
| **Clipboard History** | Clipboard management via cliphist | Keyboard shortcut |

### Power & Tools Menu Features
The power menu (`fuzzel-powermenu.sh`) includes:
- **Power Options**: Shutdown, reboot, suspend, hibernate, logout
- **System Tools**: Idle inhibitor toggle, Ventoy USB detection
- **Session Management**: Niri session save/restore
- **Performance Profiles**: Manual power profile switching
- **System Information**: Quick system status display

## Notification System

**SwayNC (Sway Notification Center)** provides a comprehensive notification management system:

### Features
- **Notification Panel**: Sliding notification center from the right
- **Widget Integration**: System status widgets and controls
- **Custom Styling**: Dark theme matching system aesthetics
- **Priority Handling**: Different timeout settings for notification types
- **Interactive Controls**: Inline replies and notification actions
- **Persistent History**: Notification history with search functionality

## Scripts & Automation

### Waybar Scripts
| Script | Description | Location |
|--------|-------------|----------|
| **start-waybar.sh** | Auto-reload waybar on config changes | `waybar/scripts/` |
| **waybar-scrolling-mpris** | MPRIS media control with scrolling | `waybar/scripts/` |
| **wlsunset.sh** | Screen temperature control script | `waybar/scripts/` |

#### Waybar Auto-Reload System
The `start-waybar.sh` script implements intelligent auto-reloading:
- **File Monitoring**: Uses `inotifywait` to watch for configuration changes
- **Graceful Restart**: Sends SIGUSR2 signal to waybar for hot-reloading
- **Change Detection**: Monitors all files in `~/.config/waybar/` recursively
- **Automatic Recovery**: Restarts waybar if it crashes or stops responding

### Niri Scripts
| Script | Description | Location |
|--------|-------------|----------|
| **niri-with-session.sh** | Niri startup with session management | `niri/scripts/` |
| **save-session.sh** | Advanced session state preservation | `niri/scripts/` |
| **restore-session.sh** | Intelligent session restoration | `niri/scripts/` |
| **keyboard-brightness.sh** | Keyboard backlight control | `niri/scripts/` |

#### Niri Session Management System
The session management system provides comprehensive state preservation:

**Session Saving (`save-session.sh`)**:
- **Window Tracking**: Records all open applications with their workspace assignments
- **Focus Preservation**: Saves currently focused application for restoration priority
- **Workspace Mapping**: Maintains workspace-to-application relationships
- **Smart Filtering**: Excludes system processes and invalid entries
- **Duplicate Handling**: Removes duplicate entries while preserving order

**Session Restoration (`restore-session.sh`)**:
- **Intelligent Loading**: Restores applications in their original workspaces
- **Focus Restoration**: Returns focus to the previously active application
- **Startup Sequencing**: Handles application startup timing and dependencies
- **Error Recovery**: Gracefully handles missing or failed applications

### Fuzzel Scripts
| Script | Description | Location |
|--------|-------------|----------|
| **fuzzel-powermenu.sh** | Comprehensive power and system menu | `fuzzel/scripts/` |

### System Scripts
| Script | Description | Location |
|--------|-------------|----------|
| **auto-performance.sh** | System-wide performance management | `scripts/` |
| **setup-refind.sh** | rEFInd configuration management | `refind/` |

## Applications

| Application | Description | Link |
|-------------|-------------|------|
| **[Ghostty](https://github.com/mitchellh/ghostty)** | Terminal | [GitHub](https://github.com/mitchellh/ghostty) |
| **[VS Code](https://code.visualstudio.com/)** | Code editor | [GitHub](https://github.com/microsoft/vscode) |
| **[MPV](https://mpv.io/)** | Media player | [GitHub](https://github.com/mpv-player/mpv) |
| **[Nautilus](https://wiki.gnome.org/Apps/Files)** | File manager | [GitHub](https://github.com/GNOME/nautilus) |
| **[Legcord](https://github.com/legcord/legcord)** | Discord client | [GitHub](https://github.com/legcord/legcord) |
| **[Stremio](https://www.stremio.com/)** | Streaming platform | [GitHub](https://github.com/Stremio/stremio-shell) |
| **[Grayjay](https://gitlab.futo.org/videostreaming/Grayjay.Desktop)** | YouTube client | [GitLab](https://gitlab.futo.org/videostreaming/Grayjay.Desktop) |
| **[Zen Browser](https://github.com/zen-browser/desktop)** | Privacy-focused browser | [GitHub](https://github.com/zen-browser/desktop) |
| **Spotify** | Music streaming | - |
| **[virt-manager](https://github.com/virt-manager/virt-manager)** | Virtual machine manager | [GitHub](https://github.com/virt-manager/virt-manager) |

## Installation

```bash
# Install dependencies
sudo pacman -S niri waybar fuzzel swaync swaylock ghostty mpv xwayland-satellite polkit-mate swaybg swayidle wl-clipboard wlsunset cliphist bzmenu iwmenu syshud refind

# Clone repository
git clone --recursive https://github.com/ang3lo-azevedo/dotfiles.git ~/.config

# Setup auto-performance service
cd ~/.config/auto-performance
chmod +x install.sh
./install.sh system

# Setup rEFInd configuration management
cd ~/.config/refind
chmod +x setup-refind.sh
./setup-refind.sh copy    # Copy current config from /boot
./setup-refind.sh link    # Setup sync mechanism (symlinks or copy-based)
```

**Note**: Most EFI system partitions use FAT32, which doesn't support symlinks. The script automatically detects this and uses a copy-based sync mechanism instead.
```

## Structure

```
~/.config/
├── niri/               # Window manager
│   └── scripts/        # Niri automation scripts
├── waybar/             # Status bar
│   └── scripts/        # Waybar utility scripts
├── fuzzel/             # Application launcher
│   └── scripts/        # Fuzzel menu scripts
├── swaync/             # Notification center
├── swaylock/           # Lock screen
├── ghostty/            # Terminal
├── mpv/                # Media player
├── refind/             # rEFInd bootloader configuration
├── auto-performance/   # Automatic power profile management
└── scripts/            # System-wide scripts
```

## Maintenance

```bash
# Update submodules
git submodule update --remote

# Backup before updates
cp -r ~/.config ~/.config.backup

# Update auto-performance service
systemctl --user restart auto-performance@$USER.service

# Sync rEFInd configuration (for FAT32 EFI partitions)
cd ~/.config/refind
./setup-refind.sh sync     # Sync changes from dotfiles to /boot
./setup-refind.sh status   # Check current status
```

## Features

- **Fuzzel-Centric Interface**: Unified menu system using Fuzzel for most interactions including power menu, system tools, and application launching
- **Auto-Reload System**: Waybar automatically reloads when configuration files change, eliminating the need for manual restarts
- **Advanced Session Management**: Niri session save/restore system preserves window layouts, workspace assignments, and focus states
- **Intelligent Notification Center**: SwayNC provides comprehensive notification management with widgets and persistent history
- **Automatic Power Management**: The auto-performance service automatically switches between performance and power-saving modes based on AC adapter status
- **Integrated System Menus**: Bluetooth (bzmenu), network (iwmenu), and clipboard (cliphist) management through consistent Fuzzel-based interfaces
- **rEFInd Integration**: Automated configuration management with intelligent sync handling for FAT32 EFI partitions
- **Screen Temperature Control**: Automatic adjustment via wlsunset integration with manual controls
- **Keyboard Backlight Management**: Automated keyboard brightness control with ambient light detection
- **Media Control Integration**: Waybar MPRIS controls with scrolling support for easy media management

---

<div align="center">

**If this repository was helpful to you, consider giving it a star!**

</div>
