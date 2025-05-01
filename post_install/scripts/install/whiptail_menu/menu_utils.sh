#! /bin/bash

# Set the variables
backtitle="Ângelo's Arch Linux Post-Installation Setup"
title="Installation Options"
height=8
width=60

# Function to install whiptail if not present
install_whiptail() {
    if ! command_exists "whiptail"; then
        print_status "Installing whiptail..."
        sudo pacman -S --noconfirm whiptail
    fi
}

# Function to show a yes/no message
yes_no_message() {
    local message=$1

    whiptail --clear --backtitle "$backtitle" --title "$title" --yesno "$message" $height $width
}

# Function to show the welcome message
welcome_message() {
    whiptail --clear --backtitle "$backtitle" --title "$title" --msgbox "Welcome to my Arch Linux Post-Installation Setup" $height $width
}