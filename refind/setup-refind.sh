#!/bin/bash

# rEFInd Configuration Management Script
# This script copies rEFInd configuration from /boot and creates symlinks

set -e

REFIND_CONFIG_DIR="$HOME/.config/refind"
BOOT_REFIND_DIR="/boot/EFI/refind"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root for certain operations
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root for safety reasons."
        print_status "Use sudo only when prompted for specific operations."
        exit 1
    fi
}

# Function to backup existing files
backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local backup
        backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Backing up $file to $backup"
        sudo cp "$file" "$backup"
    fi
}

# Function to copy rEFInd configuration from /boot
copy_refind_config() {
    print_status "Copying rEFInd configuration from $BOOT_REFIND_DIR"
    
    # Create config directory if it doesn't exist
    mkdir -p "$REFIND_CONFIG_DIR"
    
    # Check if boot directory exists (using sudo since /boot has restricted permissions)
    if ! sudo test -d "$BOOT_REFIND_DIR"; then
        print_error "rEFInd directory not found at $BOOT_REFIND_DIR"
        print_status "Please ensure rEFInd is installed and mounted properly"
        
        # Try alternative common locations
        print_status "Checking alternative locations..."
        for alt_path in "/boot/refind" "/efi/EFI/refind" "/boot/efi/EFI/refind"; do
            if sudo test -d "$alt_path"; then
                print_status "Found rEFInd at $alt_path"
                BOOT_REFIND_DIR="$alt_path"
                break
            fi
        done
        
        if ! sudo test -d "$BOOT_REFIND_DIR"; then
            exit 1
        fi
    fi
    
    # Copy main configuration file
    if sudo test -f "$BOOT_REFIND_DIR/refind.conf"; then
        print_status "Copying refind.conf"
        sudo cp "$BOOT_REFIND_DIR/refind.conf" "$REFIND_CONFIG_DIR/"
        sudo chown "$USER:$USER" "$REFIND_CONFIG_DIR/refind.conf"
        print_success "refind.conf copied successfully"
    else
        print_warning "refind.conf not found in $BOOT_REFIND_DIR"
    fi
    
    # Copy themes if they exist
    if sudo test -d "$BOOT_REFIND_DIR/themes"; then
        print_status "Copying themes directory"
        sudo cp -r "$BOOT_REFIND_DIR/themes" "$REFIND_CONFIG_DIR/"
        sudo chown -R "$USER:$USER" "$REFIND_CONFIG_DIR/themes"
        print_success "Themes copied successfully"
    else
        print_status "No themes directory found"
    fi
    
    # Copy refind-black theme if it exists (common custom theme)
    if sudo test -d "$BOOT_REFIND_DIR/refind-black"; then
        print_status "Copying refind-black theme directory"
        sudo cp -r "$BOOT_REFIND_DIR/refind-black" "$REFIND_CONFIG_DIR/"
        sudo chown -R "$USER:$USER" "$REFIND_CONFIG_DIR/refind-black"
        print_success "refind-black theme copied successfully"
    fi
    
    # Copy icons if they exist
    if sudo test -d "$BOOT_REFIND_DIR/icons"; then
        print_status "Copying icons directory"
        sudo cp -r "$BOOT_REFIND_DIR/icons" "$REFIND_CONFIG_DIR/"
        sudo chown -R "$USER:$USER" "$REFIND_CONFIG_DIR/icons"
        print_success "Icons copied successfully"
    else
        print_status "No custom icons directory found"
    fi
    
    # Copy any other configuration files
    for file in "$BOOT_REFIND_DIR"/*.conf; do
        # Use sudo to check file existence due to /boot permissions
        if sudo test -f "$file" && [[ "$(basename "$file")" != "refind.conf" ]]; then
            local filename
            filename=$(basename "$file")
            print_status "Copying $filename"
            sudo cp "$file" "$REFIND_CONFIG_DIR/"
            sudo chown "$USER:$USER" "$REFIND_CONFIG_DIR/$filename"
        fi
    done
}

# Function to create symlinks from config directory to /boot
create_symlinks() {
    print_status "Creating symlinks from $REFIND_CONFIG_DIR to $BOOT_REFIND_DIR"
    
    # Check if the boot filesystem supports symlinks
    local test_symlink="/boot/test_symlink_$$"
    if ! sudo ln -s /tmp "$test_symlink" 2>/dev/null; then
        print_warning "Boot filesystem doesn't support symlinks (likely FAT32)"
        print_status "Using copy-based sync instead of symlinks"
        print_status "Note: Changes in dotfiles will need manual sync with 'restore' command"
        
        # Clean up test
        sudo rm -f "$test_symlink" 2>/dev/null || true
        
        # Use copy instead of symlinks
        restore_from_config
        return
    fi
    
    # Clean up successful test
    sudo rm -f "$test_symlink"
    
    # Backup existing files in /boot before creating symlinks
    if [[ -f "$BOOT_REFIND_DIR/refind.conf" ]]; then
        backup_file "$BOOT_REFIND_DIR/refind.conf"
    fi
    
    # Create symlink for main config file
    if [[ -f "$REFIND_CONFIG_DIR/refind.conf" ]]; then
        print_status "Creating symlink for refind.conf"
        sudo rm -f "$BOOT_REFIND_DIR/refind.conf"
        sudo ln -s "$REFIND_CONFIG_DIR/refind.conf" "$BOOT_REFIND_DIR/refind.conf"
        print_success "refind.conf symlink created"
    fi
    
    # Create symlinks for themes
    if [[ -d "$REFIND_CONFIG_DIR/themes" ]]; then
        print_status "Creating symlink for themes directory"
        sudo rm -rf "$BOOT_REFIND_DIR/themes"
        sudo ln -s "$REFIND_CONFIG_DIR/themes" "$BOOT_REFIND_DIR/themes"
        print_success "Themes symlink created"
    fi
    
    # Create symlinks for icons
    if [[ -d "$REFIND_CONFIG_DIR/icons" ]]; then
        print_status "Creating symlink for icons directory"
        sudo rm -rf "$BOOT_REFIND_DIR/icons"
        sudo ln -s "$REFIND_CONFIG_DIR/icons" "$BOOT_REFIND_DIR/icons"
        print_success "Icons symlink created"
    fi
    
    # Create symlinks for other config files
    for file in "$REFIND_CONFIG_DIR"/*.conf; do
        if [[ -f "$file" ]] && [[ "$(basename "$file")" != "refind.conf" ]]; then
            local filename
            filename=$(basename "$file")
            print_status "Creating symlink for $filename"
            sudo rm -f "$BOOT_REFIND_DIR/$filename"
            sudo ln -s "$file" "$BOOT_REFIND_DIR/$filename"
        fi
    done
}

# Function to remove symlinks and restore from config
restore_from_config() {
    print_status "Restoring rEFInd configuration from dotfiles to /boot"
    
    # Remove existing symlinks and copy files directly
    for item in "$REFIND_CONFIG_DIR"/*; do
        if [[ -e "$item" ]]; then
            local basename_item
            basename_item=$(basename "$item")
            local boot_item="$BOOT_REFIND_DIR/$basename_item"
            
            # Remove existing file/link in /boot
            if [[ -L "$boot_item" ]] || [[ -f "$boot_item" ]] || [[ -d "$boot_item" ]]; then
                print_status "Removing existing $basename_item in /boot"
                sudo rm -rf "$boot_item"
            fi
            
            # Copy from config directory
            print_status "Copying $basename_item to /boot"
            sudo cp -r "$item" "$boot_item"
        fi
    done
    
    print_success "rEFInd configuration restored from dotfiles"
}

# Main function
main() {
    print_status "rEFInd Configuration Management"
    print_status "==============================="
    
    case "${1:-}" in
        "copy"|"")
            check_root
            copy_refind_config
            print_success "rEFInd configuration copied to dotfiles"
            print_status "Run '$0 link' to create symlinks"
            ;;
        "link")
            check_root
            if [[ ! -f "$REFIND_CONFIG_DIR/refind.conf" ]]; then
                print_error "No rEFInd configuration found in dotfiles"
                print_status "Run '$0 copy' first to copy configuration from /boot"
                exit 1
            fi
            create_symlinks
            print_success "Symlinks created successfully"
            ;;
        "restore")
            check_root
            restore_from_config
            ;;
        "sync")
            check_root
            if [[ ! -f "$REFIND_CONFIG_DIR/refind.conf" ]]; then
                print_error "No rEFInd configuration found in dotfiles"
                print_status "Run '$0 copy' first to copy configuration from /boot"
                exit 1
            fi
            print_status "Syncing dotfiles configuration to /boot"
            restore_from_config
            ;;
        "status")
            print_status "Checking rEFInd configuration status"
            if sudo test -L "$BOOT_REFIND_DIR/refind.conf"; then
                print_success "refind.conf is symlinked to: $(sudo readlink "$BOOT_REFIND_DIR/refind.conf")"
            elif sudo test -f "$BOOT_REFIND_DIR/refind.conf"; then
                print_warning "refind.conf exists but is not a symlink (likely FAT32 filesystem)"
                print_status "Use '$0 sync' to update /boot from dotfiles"
            else
                print_error "refind.conf not found in /boot"
            fi
            ;;
        "help"|"-h"|"--help")
            echo "Usage: $0 [command]"
            echo ""
            echo "Commands:"
            echo "  copy     Copy rEFInd configuration from /boot to dotfiles (default)"
            echo "  link     Create symlinks from dotfiles to /boot (or copy if unsupported)"
            echo "  sync     Sync dotfiles configuration to /boot (for FAT32 filesystems)"
            echo "  restore  Copy configuration from dotfiles to /boot (removes symlinks)"
            echo "  status   Check current symlink status"
            echo "  help     Show this help message"
            echo ""
            echo "Typical workflow:"
            echo "  1. $0 copy    # Copy current /boot config to dotfiles"
            echo "  2. $0 link    # Create symlinks (or copy if filesystem doesn't support symlinks)"
            echo "  3. $0 sync    # Sync changes from dotfiles to /boot (when symlinks unavailable)"
            ;;
        *)
            print_error "Unknown command: $1"
            print_status "Use '$0 help' for available commands"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
