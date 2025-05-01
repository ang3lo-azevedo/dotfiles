#!/bin/bash

dir=$(dirname "$0")

# Source the utils
source "$dir/utils.sh"

# Source the menu utils
source "$dir/menu_utils.sh"

# Set the variables
backtitle="Ângelo's Arch Linux Post-Installation Setup"
height=8
width=60

# Function to show the multithreading message
multithread_make_message() {
    yes_no_message "Enable multithreading in makepkg?" 
    if [ $? -eq 0 ]; then
        choices+=("multithread_make")
        # Get number of threads
        thread_count=$(whiptail --clear \
            --backtitle "$backtitle" \
            --title "Thread Count" \
            --inputbox "Enter number of threads to use (recommended: number of CPU cores):" \
            $height $width \
            "$cpu_cores" \
            3>&1 1>&2 2>&3)
        # If user cancels thread input, remove multithread_make from choices
        if [ $? -ne 0 ]; then
            choices=("${choices[@]/multithread_make}")
        fi
    fi
}

# Function to show the parallel downloads message
parallel_downloads_message() {
    yes_no_message "Enable parallel downloads in pacman?"
    if [ $? -eq 0 ]; then
            choices+=("parallel_downloads")
            # Get number of parallel downloads
            parallel_downloads=$(whiptail --clear \
                --backtitle "$backtitle" \
                --title "Parallel Downloads" \
                --inputbox "Enter number of parallel downloads (recommended: number of CPU cores):" \
                $height $width \
                "$cpu_cores" \
                3>&1 1>&2 2>&3)
            # If user cancels parallel downloads input, remove parallel_downloads from choices
            if [ $? -ne 0 ]; then
                choices=("${choices[@]/parallel_downloads}")
            fi
        fi
}

# Function to show the NVIDIA drivers message
nvidia_drivers_message() {
    yes_no_message "Install NVIDIA Drivers?"
    if [ $? -eq 0 ]; then
        choices+=("nvidia")
    fi
}

# Function to show the yay message
yay_message() {
    yes_no_message "Install yay?"
    if [ $? -eq 0 ]; then
        choices+=("yay")
    fi
}

# Function to show the packages message
packages_message() {
    yes_no_message "Install packages?"
    if [ $? -eq 0 ]; then
        choices+=("packages")
    fi
}

# Function to show the main menu
menu() {
    install_whiptail

    # Get the number of CPU cores
    cpu_cores=$(nproc)

    welcome_message

    while true; do
        choices=()
        thread_count=0
        parallel_downloads=0
        
        multithread_make_message
        parallel_downloads_message
        nvidia_drivers_message
        yay_message
        packages_message

        # Process selected options
        for choice in "${choices[@]}"; do
            case $choice in
                "multithread_make") source "$(dirname "$0")/configs/multithread_make.sh" && multithread_make "$thread_count" ;;
                "parallel_downloads") source "$(dirname "$0")/configs/parallel_downloads.sh" && parallel_downloads "$parallel_downloads" ;;
                "nvidia") source "$(dirname "$0")/nvidia.sh" && install_nvidia ;;
                "yay") source "$(dirname "$0")/yay.sh" && install_yay ;;
                "packages") source "$(dirname "$0")/packages.sh" && install_packages ;;
            esac
        done
    done
}