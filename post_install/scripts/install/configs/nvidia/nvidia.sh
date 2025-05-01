#!/bin/bash

dir=$(dirname "$0")

# Source the utils
source "$dir/utils.sh"

# Function to install NVIDIA drivers
install_nvidia() {
    print_status "Installing NVIDIA drivers..."
    
    # Install base NVIDIA packages
    install_package "nvidia-dkms"
    install_package "nvidia-utils"
    install_package "nvidia-settings"
    
    # Install additional useful packages
    install_package "lib32-nvidia-utils"  # For 32-bit applications
    install_package "nvidia-prime"        # For hybrid graphics support
    
    # Create NVIDIA configuration directory if it doesn't exist
    mkdir -p /etc/pacman.d/hooks
    
    # Create pacman hook for NVIDIA
    cat > /etc/pacman.d/hooks/nvidia.hook << 'EOF'
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOF

    # Configure mkinitcpio for NVIDIA
    print_status "Configuring mkinitcpio for NVIDIA..."
    
    # Backup original mkinitcpio.conf
    cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup
    
    # Add NVIDIA modules to mkinitcpio
    sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    
    # Add NVIDIA hooks to mkinitcpio
    sed -i 's/HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block filesystems fsck)/HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block filesystems fsck nvidia)/' /etc/mkinitcpio.conf
    
    # Regenerate initramfs
    print_status "Regenerating initramfs..."
    mkinitcpio -P

    print_status "NVIDIA installation and configuration completed!"
    print_status "Please reboot your system for changes to take effect."
}

# Main execution
install_nvidia 