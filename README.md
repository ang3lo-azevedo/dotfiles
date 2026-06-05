# NixOS Configuration

[![NixOS](https://img.shields.io/badge/OS-NixOS-blue?style=flat-square&logo=nixos)](https://nixos.org/)
[![Niri](https://img.shields.io/badge/WM-Niri-purple?style=flat-square)](https://github.com/YaLTeR/niri)
[![Wayland](https://img.shields.io/badge/Display-Wayland-green?style=flat-square)](https://wayland.freedesktop.org/)
[![zsh](https://img.shields.io/badge/Shell-zsh-orange?style=flat-square&logo=gnu-bash)](https://www.zsh.org/)

My personal Linux system configurations for **NixOS** with **CachyOS kernel optimizations** and **Niri** as the window manager, managed declaratively via Flakes.

![Screenshot](https://github.com/user-attachments/assets/1ef97088-009f-4057-b50d-f780c1e17055)

![Screenshot](https://github.com/user-attachments/assets/9b720767-7de0-4e10-82cf-917bbb908fd3)

![Screenshot](https://github.com/user-attachments/assets/8534ea57-1427-497e-be2d-31c415e97bf2)

## Setup Summary

Simple, efficient, and reproducible setup using **NixOS** and **Home Manager**. It leverages the performance optimizations of the **CachyOS kernel**, a modern **Wayland** environment with the **Niri** rolling window manager, and a highly streamlined workflow powered by **Fuzzel**. The entire configuration is declarative, making it easy to replicate across machines.

## System

| Component | Choice | Link |
|-----------|--------|------|
| **OS** | NixOS | [GitHub](https://github.com/NixOS/nixpkgs) |
| **Kernel** | CachyOS Kernel | [GitHub](https://github.com/xddxdd/nix-cachyos-kernel) |
| **Bootloader** | systemd-boot | [Freedesktop](https://systemd.io/BOOT/) |
| **Window Manager** | Niri | [GitHub](https://github.com/YaLTeR/niri) |
| **Shell** | zsh | [GitHub](https://github.com/zsh-users/zsh) |

## Theming

System-wide theming is managed dynamically via **Stylix**, ensuring a cohesive aesthetic across GTK, Qt, and the terminal.

| Component | Theme | Description |
|-----------|-------|-------------|
| **GTK/Qt Applications** | Stylix Managed | Consistent dark mode styling across all graphical apps |
| **Cursor Theme** | Stylix Managed | Consistent cursor appearance applied globally |
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
| **polkit-gnome** | Authentication agent | [GitLab](https://gitlab.gnome.org/GNOME/polkit-gnome) |
| **[swaybg](https://github.com/swaywm/swaybg)** | Background wallpaper | [GitHub](https://github.com/swaywm/swaybg) |
| **[swayidle](https://github.com/swaywm/swayidle)** | Idle management daemon | [GitHub](https://github.com/swaywm/swayidle) |
| **[wlsunset](https://gitlab.com/chinstrap/wlsunset)** | Automatic screen temperature adjustment | [GitLab](https://gitlab.com/chinstrap/wlsunset) |
| **[cliphist](https://github.com/sentriz/cliphist)** | Clipboard history | [GitHub](https://github.com/sentriz/cliphist) |
| **[bzmenu](https://github.com/e-tho/bzmenu)** | Bluetooth device menu | [GitHub](https://github.com/e-tho/bzmenu) |
| **[iwmenu](https://github.com/e-tho/iwmenu)** | Network interface menu | [GitHub](https://github.com/e-tho/iwmenu) |

## Menu System & Interface

The system utilizes **Fuzzel** as the primary menu interface for system interactions, integrated via Home Manager modules:

### Fuzzel Menu Integration
| Menu Type | Description | Trigger |
|-----------|-------------|---------|
| **Application Launcher** | Standard app launcher with fuzzel | Super key or waybar click |
| **Power Menu** | System power options (pwmenu) | Waybar / Shortcut |
| **Bluetooth Menu** | Device connection via bzmenu | Waybar bluetooth widget |
| **Network Menu** | WiFi management via iwmenu | Waybar network widget |
| **Clipboard History** | Clipboard management via cliphist | Keyboard shortcut |

## Notification System

**SwayNC (Sway Notification Center)** provides a comprehensive notification management system:

### Features
- **Notification Panel**: Sliding notification center from the right
- **Widget Integration**: System status widgets and controls
- **Custom Styling**: Declaratively configured to match system aesthetics
- **Interactive Controls**: Inline replies and notification actions
- **Persistent History**: Notification history with search functionality

## Applications

A robust set of applications configured declaratively:

| Application | Description |
|-------------|-------------|
| **[Ghostty](https://github.com/mitchellh/ghostty)** | GPU-accelerated terminal emulator |
| **[Zen Browser](https://github.com/zen-browser/desktop)** | Privacy-focused browser |
| **Antigravity / VS Code** | Code editors |
| **[MPV](https://mpv.io/)** | Media player |
| **[Nautilus](https://wiki.gnome.org/Apps/Files)** | File manager |
| **[Nixcord](https://github.com/FlameFlag/nixcord)** | Discord client customized via Nix |
| **Stremio Enhanced** | Streaming platform |
| **YouTube Music** | Managed via Pear Desktop / youtube-music-nix |
| **[virt-manager](https://github.com/virt-manager/virt-manager)** | Virtual machine manager |
| **Spotify** | Managed and themed via Spicetify-nix |

## Cyber Security & Reverse Engineering

This configuration includes a dedicated suite of tools for cybersecurity, reverse engineering, and binary analysis:

| Tool | Description |
|------|-------------|
| **IDA Pro** | Disassembler and debugger (managed via `ida-pro-overlay`) |
| **Binary Ninja** | Reverse engineering platform (managed via `nix-binary-ninja`) |
| **pwndbg** | Exploit development and reverse engineering plugin for GDB |
| **angr-management** | GUI for the angr binary analysis framework |
| **Wireshark** | Network protocol analyzer |
| **MemProcFS** | PCIE DMA analysis and memory forensics (via `dmatools` overlay) |
| **QRookie** | Reverse engineering and analysis tool (via `glaumar_repo` NUR) |
| **registry-spy** | Tool to inspect Windows registry files |
| **dnspy** | .NET assembly editor, decompiler, and debugger |

## Custom Packages (Built in Flake)

The flake directly builds and exposes several custom packages:

| Package | Description |
|---------|-------------|
| **angr-management** | Packaged from source for binary analysis |
| **archi** | ArchiMate modelling tool |
| **nuvio-desktop** | Custom desktop application |
| **registry-spy** | Windows registry inspection tool |
| **dnspy** | .NET assembly editing tool |

## Code Editors Architecture

The setup includes a highly specialized and modular configuration for **VS Code**, **Cursor**, and **Antigravity IDE**:

- **Unified Configuration**: All editors share a centralized baseline of settings and extensions defined in `shared-settings.nix` and `shared-extensions.nix`.
- **Nix-Managed Extensions**: Extensions are declaratively fetched via `nix-vscode-extensions` and robustly symlinked directly into the respective editor's extension directory (e.g., `~/.vscode/extensions`, `~/.cursor/extensions`, `~/.antigravity-ide/extensions`).
- **Resilient Symlinking**: The extension linking script parses `package.json` dynamically to generate both standard and versioned/architecture-specific symlinks (e.g., `-universal`). This satisfies strict internal IDE caching mechanisms (`state.vscdb`) and prevents extension scanner crashes.
- **Mutable Settings with Nix Baseline**: Settings are generated declaratively via Nix, but injected into the IDE's user directories dynamically as writable files via Home Manager activation scripts. This hybrid approach ensures you can freely toggle settings directly inside the IDE without read-only warnings, while reapplying the Nix baseline on every system rebuild.
- **Per-Editor Overrides**: Individual editors seamlessly extend the shared baseline. For example, Antigravity IDE defines its own `settings.nix` and `extensions.nix` to enforce specific themes while inheriting all global tooling.

## Installation

```bash
# Clone the repository
git clone https://github.com/ang3lo-azevedo/nix-config.git ~/nix-config
cd ~/nix-config

# Apply the NixOS system configuration (for pc-angelo)
sudo nixos-rebuild switch --flake .#pc-angelo
```

*Note: For the standalone Home Manager configuration without the full system flake, use `home-manager switch --flake .#ang3lo`.*

## Structure

```
nix-config/
├── flake.nix           # Flake entrypoint and inputs
├── hosts/              # Host-specific configurations (e.g., pc-angelo, server-angelo)
├── modules/            # Reusable Nix modules
│   ├── system/         # System-level NixOS configurations
│   └── home-manager/   # User-level Home Manager configurations
├── pkgs/               # Custom and locally built packages
├── overlays/           # Nixpkgs overlays
├── secrets/            # Agenix encrypted secrets
├── shells/             # Development shells
└── home/               # User-specific entrypoints (home.nix)
```

## Maintenance

```bash
# Update flake inputs
nix flake update

# Apply system changes
sudo nixos-rebuild switch --flake .#pc-angelo

# Apply Home Manager changes (if using standalone Home Manager)
home-manager switch --flake .#ang3lo
```

## Features

- **Declarative & Reproducible**: The entire system is managed via Nix Flakes, eliminating configuration drift.
- **Performance Optimized**: Uses the `nix-cachyos-kernel` and `auto-cpufreq` for maximum performance and responsiveness.
- **Fuzzel-Centric Interface**: Unified menu system using Fuzzel for most interactions, including power menus and system tools.
- **Dynamic Theming**: Integrated `stylix` dynamically themes the system for a consistent appearance.
- **Secrets Management**: Securely managed secrets via `agenix`.
- **Integrated System Menus**: Bluetooth (`bzmenu`), network (`iwmenu`), and clipboard (`cliphist`) management through lightweight Wayland-native interfaces.

---

<div align="center">

**If this repository was helpful to you, consider giving it a star!**

</div>
