# Dotfiles

My personal Linux system configurations for CachyOS with Niri as window manager.

![Screenshot](https://github.com/user-attachments/assets/41f27464-a888-48be-840e-224584a6bc45)

## Setup Summary

Simple and efficient setup using CachyOS (Arch-based with performance optimizations) with Wayland and Niri as a rolling window manager. Minimal color usage, direct and effective workflow with Fuzzel handling most menu interactions for a streamlined development environment.

## System

- **OS**: [CachyOS](https://cachyos.org/)
- **Bootloader**: [systemd-boot](https://systemd.io/BOOT_LOADER_INTERFACE/)
- **Window Manager**: [Niri](https://github.com/smithay/niri)

## Window Manager Components

- **[Niri](https://github.com/smithay/niri)**: Window manager and compositor
- **[Waybar](https://github.com/Alexays/Waybar)**: Status bar
- **[Fuzzel](https://codeberg.org/dnkl/fuzzel)**: Application launcher
- **[Mako](https://github.com/emersion/mako)**: Notifications
- **[Swaylock](https://github.com/swaywm/swaylock)**: Lock screen
- **[xwayland-satellite](https://github.com/smithay/niri)**: XWayland support for Niri
- **[polkit-mate](https://github.com/mate-desktop/mate-polkit)**: Authentication agent
- **[swaybg](https://github.com/swaywm/swaybg)**: Background wallpaper
- **[swayidle](https://github.com/swaywm/swayidle)**: Idle management daemon
- **[wlsunset](https://gitlab.com/chinstrap/wlsunset)**: Automatic screen temperature adjustment
- **[cliphist](https://github.com/sentriz/cliphist)**: Clipboard history
- **[bzmenu](https://github.com/0pointer/bzmenu)**: Bluetooth device menu
- **[iwmenu](https://github.com/0pointer/iwmenu)**: Network interface menu

## Applications

- **[Ghostty](https://github.com/mitchellh/ghostty)**: Terminal
- **[Cursor](https://cursor.sh/)**: Code editor
- **[MPV](https://mpv.io/)**: Media player
- **[Nautilus](https://wiki.gnome.org/Apps/Files)**: File manager

## Installation

```bash
# Install dependencies
sudo pacman -S niri waybar fuzzel mako swaylock ghostty mpv xwayland-satellite polkit-mate swaybg swayidle wl-clipboard wlsunset cliphist bzmenu iwmenu

# Clone repository
git clone --recursive https://github.com/your-username/dotfiles.git ~/.config
```

## Structure

```
~/.config/
├── niri/           # Window manager
├── waybar/         # Status bar
├── ghostty/        # Terminal
├── Cursor/         # Code editor
├── mpv/            # Media player
├── fuzzel/         # Launcher
├── mako/           # Notifications
├── swaylock/       # Lock screen
├── gtk-3.0/        # GTK theme
├── nautilus/       # File manager
└── pulse/          # Audio
```

## Maintenance

```bash
# Update submodules
git submodule update --remote

# Backup before updates
cp -r ~/.config ~/.config.backup
```
