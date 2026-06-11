# Ângelo's NixOS Config

[![NixOS](https://img.shields.io/badge/OS-NixOS-blue?style=flat-square&logo=nixos)](https://nixos.org/)
[![Niri](https://img.shields.io/badge/WM-Niri-purple?style=flat-square)](https://github.com/YaLTeR/niri)
[![Wayland](https://img.shields.io/badge/Display-Wayland-green?style=flat-square)](https://wayland.freedesktop.org/)
[![zsh](https://img.shields.io/badge/Shell-zsh-orange?style=flat-square&logo=gnu-bash)](https://www.zsh.org/)

My personal Linux system configurations for **NixOS** with **CachyOS kernel optimizations** and **Niri** as the window manager, managed declaratively via Flakes.

![Screenshot](https://github.com/user-attachments/assets/1ef97088-009f-4057-b50d-f780c1e17055)

## Overview

This repository defines a completely declarative, reproducible **NixOS** and **Home Manager** setup tailored for a modern Wayland environment. It features:
- **CachyOS Kernel**: For maximum performance and responsiveness.
- **Niri**: A rolling window manager for Wayland.
- **Stylix**: Dynamic system-wide theming.
- **Advanced Hardware Support**: Custom modules and patches for Samsung Galaxy Book specific hardware.

## Documentation (Wiki)

Detailed documentation has been moved to the [GitHub Wiki](https://github.com/ang3lo-azevedo/dotfiles/wiki) to keep this README clean. Please check the Wiki for comprehensive guides on:

- **[Installation & Setup](https://github.com/ang3lo-azevedo/dotfiles/wiki/Installation)**
- **[System Architecture & Structure](https://github.com/ang3lo-azevedo/dotfiles/wiki/Architecture)**
- **[Hardware Fixes (Samsung Galaxy Book)](https://github.com/ang3lo-azevedo/dotfiles/wiki/Hardware)**
- **[External GPU (VFIO & Passthrough)](https://github.com/ang3lo-azevedo/dotfiles/wiki/EGPU)**
- **[Cyber Security & Reverse Engineering](https://github.com/ang3lo-azevedo/dotfiles/wiki/CyberSecurity)**
- **[Kernel Optimizations (CachyOS)](https://github.com/ang3lo-azevedo/dotfiles/wiki/Kernel)**
- **[Gaming (Proton & Steam)](https://github.com/ang3lo-azevedo/dotfiles/wiki/Gaming)**

## Quick Start

```bash
# Clone the repository
git clone https://github.com/ang3lo-azevedo/dotfiles.git ~/nix-config
cd ~/nix-config

# Apply the NixOS system configuration (for pc-angelo)
sudo nixos-rebuild switch --flake .#pc-angelo
```

---

<div align="center">

**If this repository was helpful to you, consider giving it a star!**

</div>
