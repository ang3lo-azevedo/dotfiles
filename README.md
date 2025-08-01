# Dotfiles

[![CachyOS](https://img.shields.io/badge/OS-CachyOS-blue?style=flat-square&logo=archlinux)](https://cachyos.org/)
[![Niri](https://img.shields.io/badge/WM-Niri-purple?style=flat-square)](https://github.com/smithay/niri)
[![Wayland](https://img.shields.io/badge/Display-Wayland-green?style=flat-square)](https://wayland.freedesktop.org/)
[![zsh](https://img.shields.io/badge/Shell-zsh-orange?style=flat-square&logo=gnu-bash)](https://www.zsh.org/)

My personal Linux system configurations for CachyOS with Niri as window manager.

![Screenshot](https://github.com/user-attachments/assets/41f27464-a888-48be-840e-224584a6bc45)

![Screenshot](https://github.com/user-attachments/assets/4283a0c9-5b2b-4d75-9fc0-090fb4ba83ec)

## Setup Summary

Simple and efficient setup using **CachyOS** (Arch-based with performance optimizations) with **Wayland** and **Niri** as a rolling window manager. Minimal color usage, direct and effective workflow with **Fuzzel** handling most menu interactions for a streamlined development environment.

## System

| Component | Choice | Link |
|-----------|--------|------|
| **OS** | CachyOS | [GitHub](https://github.com/CachyOS/linux-cachyos) |
| **Bootloader** | systemd-boot | [GitHub](https://github.com/systemd/systemd) |
| **Window Manager** | Niri | [GitHub](https://github.com/YaLTeR/niri) |
| **Shell** | zsh | [GitHub](https://github.com/zsh-users/zsh) |

## Window Manager Components

| Component | Description | Link |
|-----------|-------------|------|
| **[Niri](https://github.com/YaLTeR/niri)** | Window manager and compositor | [GitHub](https://github.com/YaLTeR/niri) |
| **[Waybar](https://github.com/Alexays/Waybar)** | Status bar | [GitHub](https://github.com/Alexays/Waybar) |
| **[Fuzzel](https://codeberg.org/dnkl/fuzzel)** | Application launcher | [Codeberg](https://codeberg.org/dnkl/fuzzel) |
| **[Mako](https://github.com/emersion/mako)** | Notifications | [GitHub](https://github.com/emersion/mako) |
| **[Swaylock](https://github.com/swaywm/swaylock)** | Lock screen | [GitHub](https://github.com/swaywm/swaylock) |
| **[xwayland-satellite](https://github.com/Supreeeme/xwayland-satellite)** | XWayland support for Niri | [GitHub](https://github.com/Supreeeme/xwayland-satellite) |
| **[polkit-mate](https://github.com/mate-desktop/mate-polkit)** | Authentication agent | [GitHub](https://github.com/mate-desktop/mate-polkit) |
| **[swaybg](https://github.com/swaywm/swaybg)** | Background wallpaper | [GitHub](https://github.com/swaywm/swaybg) |
| **[swayidle](https://github.com/swaywm/swayidle)** | Idle management daemon | [GitHub](https://github.com/swaywm/swayidle) |
| **[wlsunset](https://gitlab.com/chinstrap/wlsunset)** | Automatic screen temperature adjustment | [GitLab](https://gitlab.com/chinstrap/wlsunset) |
| **[cliphist](https://github.com/sentriz/cliphist)** | Clipboard history | [GitHub](https://github.com/sentriz/cliphist) |
| **[bzmenu](https://github.com/e-tho/bzmenu)** | Bluetooth device menu | [GitHub](https://github.com/e-tho/bzmenu) |
| **[iwmenu](https://github.com/e-tho/iwmenu)** | Network interface menu | [GitHub](https://github.com/e-tho/iwmenu) |

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
sudo pacman -S niri waybar fuzzel mako swaylock ghostty mpv xwayland-satellite polkit-mate swaybg swayidle wl-clipboard wlsunset cliphist bzmenu iwmenu

# Clone repository
git clone --recursive https://github.com/ang3lo-azevedo/dotfiles.git ~/.config
```

## Structure

```
~/.config/
├── niri/           # Window manager
├── waybar/         # Status bar
├── fuzzel/         # Application launcher
├── mako/           # Notifications
├── swaylock/       # Lock screen
├── ghostty/        # Terminal
└── mpv/            # Media player
```

## Maintenance

```bash
# Update submodules
git submodule update --remote

# Backup before updates
cp -r ~/.config ~/.config.backup
```

---

<div align="center">

**If this repository was helpful to you, consider giving it a star!**

</div>
