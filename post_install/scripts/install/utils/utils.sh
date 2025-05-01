#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if the user is root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Please run as root"
        exit 1
    fi
}

# Function to print status
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a package if it's not already installed
install_package() {
    if ! command_exists "$1"; then
        print_status "Installing $1..."
        sudo pacman -S --noconfirm "$1"
    else
        print_status "$1 is already installed"
    fi
}

# Function to install an AUR package if it's not already installed
install_aur_package() {
    if ! command_exists "$1"; then
        print_status "Installing $1 from AUR..."
        yay -S --noconfirm "$1"
    else
        print_status "$1 is already installed"
    fi
} 