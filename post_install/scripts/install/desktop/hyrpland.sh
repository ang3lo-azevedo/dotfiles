#!/bin/bash

source "$(dirname "$0")/utils.sh"

# Function to install desktop environment and window manager
install_desktop() {
    print_status "Installing desktop environment and window manager..."
    install_package "hyprland"
    install_package "wezterm"
    install_package "swaybg"
    install_package "swaylock"
    install_package "waybar"
} 