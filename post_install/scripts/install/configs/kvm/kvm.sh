#!/bin/bash

source "$(dirname "$0")/utils.sh"

# Function to install and configure KVM with Whonix
install_kvm_whonix() {
    print_status "Installing and configuring KVM with Whonix..."
    install_package "whonix-gateway"
    install_package "whonix-workstation"
    
    # Configure KVM for Whonix
    sudo systemctl enable --now libvirtd
    sudo usermod -aG kvm,libvirt $USER
} 