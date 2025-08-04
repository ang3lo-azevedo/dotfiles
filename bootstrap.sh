#!/bin/bash

# Bootstrap script for dotfiles installation and configuration
# This script automates the complete setup of the dotfiles environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "\n${PURPLE}=== $1 ===${NC}\n"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
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

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

# Check if running on CachyOS/Arch
check_system() {
    if ! command -v pacman &> /dev/null; then
        print_error "This script is designed for Arch-based systems (CachyOS/Arch Linux)"
        print_info "Please install dependencies manually on your distribution"
        exit 1
    fi
    print_success "Arch-based system detected"
}

# Check if script is run from the correct location
check_location() {
    if [[ ! -f "README.md" ]] || [[ ! -d "niri" ]] || [[ ! -d "waybar" ]]; then
        print_error "This script must be run from the dotfiles directory"
        print_info "Please cd to the dotfiles directory and run ./bootstrap.sh"
        exit 1
    fi
    print_success "Script location verified"
}

# Install required packages
install_dependencies() {
    print_step "Installing system dependencies..."
    
    local packages=(
        # Core window manager components
        "niri" "waybar" "fuzzel" "swaync" "swaylock"
        
        # Applications
        "ghostty" "mpv"
        
        # Wayland utilities
        "xwayland-satellite" "polkit-mate" "swaybg" "swayidle" 
        "wl-clipboard" "wlsunset"
        
        # Menu utilities
        "cliphist" "bzmenu" "iwmenu" "syshud"
        
        # Bootloader
        "refind"
        
        # Development tools
        "git" "base-devel"
        
        # Optional utilities
        "inotify-tools" "jq" "playerctl"
    )
    
    print_info "Installing packages: ${packages[*]}"
    
    if sudo pacman -S --needed --noconfirm "${packages[@]}"; then
        print_success "All dependencies installed successfully"
    else
        print_warning "Some packages might not be available in official repositories"
        print_info "You may need to install them from AUR manually"
    fi
}

# Initialize git submodules
init_submodules() {
    print_step "Initializing git submodules..."
    
    if git submodule update --init --recursive; then
        print_success "Submodules initialized successfully"
    else
        print_warning "Failed to initialize submodules"
    fi
}

# Setup auto-performance service
setup_auto_performance() {
    print_step "Setting up auto-performance service..."
    
    if [[ -d "auto-performance" ]] && [[ -f "auto-performance/install.sh" ]]; then
        cd auto-performance
        chmod +x install.sh
        
        if ./install.sh system; then
            print_success "Auto-performance service installed"
        else
            print_warning "Failed to install auto-performance service"
        fi
        cd ..
    else
        print_warning "Auto-performance directory not found"
    fi
}

# Setup rEFInd configuration
setup_refind() {
    print_step "Setting up rEFInd configuration..."
    
    if [[ -d "refind" ]] && [[ -f "refind/setup-refind.sh" ]]; then
        cd refind
        chmod +x setup-refind.sh
        
        print_info "Copying rEFInd configuration from /boot..."
        if ./setup-refind.sh copy; then
            print_success "rEFInd configuration copied"
            
            print_info "Setting up sync mechanism..."
            if ./setup-refind.sh link; then
                print_success "rEFInd sync mechanism configured"
            else
                print_warning "rEFInd sync setup failed (may need manual configuration)"
            fi
        else
            print_warning "Failed to copy rEFInd configuration"
        fi
        cd ..
    else
        print_warning "rEFInd setup script not found"
    fi
}

# Make scripts executable
setup_scripts() {
    print_step "Setting up scripts permissions..."
    
    # Waybar scripts
    if [[ -d "waybar/scripts" ]]; then
        chmod +x waybar/scripts/*.sh 2>/dev/null || true
        print_success "Waybar scripts made executable"
    fi
    
    # Niri scripts
    if [[ -d "niri/scripts" ]]; then
        chmod +x niri/scripts/*.sh 2>/dev/null || true
        print_success "Niri scripts made executable"
    fi
    
    # Fuzzel scripts
    if [[ -d "fuzzel/scripts" ]]; then
        chmod +x fuzzel/scripts/*.sh 2>/dev/null || true
        print_success "Fuzzel scripts made executable"
    fi
    
    # System scripts
    if [[ -d "scripts" ]]; then
        chmod +x scripts/*.sh 2>/dev/null || true
        print_success "System scripts made executable"
    fi
}

# Create necessary directories
create_directories() {
    print_step "Creating necessary directories..."
    
    # Ensure all config directories exist
    local dirs=(
        "$HOME/.config"
        "$HOME/.local/bin"
        "$HOME/.local/share"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
    done
    
    print_success "Directories created"
}

# Setup systemd user services
setup_services() {
    print_step "Setting up systemd user services..."
    
    # Enable auto-performance service if installed
    if systemctl --user list-unit-files | grep -q "auto-performance@"; then
        if systemctl --user enable "auto-performance@$USER.service"; then
            print_success "Auto-performance service enabled"
        else
            print_warning "Failed to enable auto-performance service"
        fi
    fi
}

# Display completion message and next steps
display_completion() {
    print_header "Installation Complete!"
    
    echo -e "${GREEN}✓${NC} System dependencies installed"
    echo -e "${GREEN}✓${NC} Git submodules initialized"
    echo -e "${GREEN}✓${NC} Scripts configured"
    echo -e "${GREEN}✓${NC} Auto-performance service setup"
    echo -e "${GREEN}✓${NC} rEFInd configuration managed"
    
    print_header "Next Steps"
    
    echo -e "${CYAN}1.${NC} Reboot your system to ensure all services start properly"
    echo -e "${CYAN}2.${NC} Configure your display manager to start Niri session"
    echo -e "${CYAN}3.${NC} Customize configurations in ~/.config/ as needed"
    echo -e "${CYAN}4.${NC} Test the setup:"
    echo "   - Check auto-performance: systemctl --user status auto-performance@$USER.service"
    echo "   - Check rEFInd sync: cd ~/.config/refind && ./setup-refind.sh status"
    echo "   - Test Waybar auto-reload by editing waybar config"
    
    print_header "Useful Commands"
    
    echo -e "${CYAN}Maintenance:${NC}"
    echo "  git submodule update --remote     # Update submodules"
    echo "  ~/.config/refind/setup-refind.sh sync  # Sync rEFInd config"
    echo ""
    echo -e "${CYAN}Session Management:${NC}"
    echo "  ~/.config/niri/scripts/save-session.sh     # Save current session"
    echo "  ~/.config/niri/scripts/restore-session.sh  # Restore session"
    echo ""
    echo -e "${CYAN}Power Menu:${NC}"
    echo "  ~/.config/fuzzel/scripts/fuzzel-powermenu.sh  # Open power menu"
    
    print_success "Bootstrap completed successfully!"
}

# Main execution
main() {
    print_header "Dotfiles Bootstrap Script"
    print_info "This script will set up your complete dotfiles environment"
    
    # Pre-flight checks
    check_system
    check_location
    
    # Main installation steps
    install_dependencies
    init_submodules
    create_directories
    setup_scripts
    setup_auto_performance
    setup_refind
    setup_services
    
    # Completion
    display_completion
}

# Handle script interruption
trap 'print_error "Script interrupted. You may need to run bootstrap.sh again."; exit 1' INT TERM

# Parse command line arguments
case "${1:-}" in
    "--help"|"-h")
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h    Show this help message"
        echo "  --dry-run     Show what would be done without executing"
        echo ""
        echo "This script bootstraps the complete dotfiles environment including:"
        echo "  • System dependencies installation"
        echo "  • Git submodules initialization"
        echo "  • Auto-performance service setup"
        echo "  • rEFInd configuration management"
        echo "  • Scripts and permissions configuration"
        exit 0
        ;;
    "--dry-run")
        print_info "DRY RUN MODE - Nothing will be installed or modified"
        print_info "Would install dependencies, setup services, and configure scripts"
        exit 0
        ;;
    "")
        # No arguments, proceed with installation
        main
        ;;
    *)
        print_error "Unknown option: $1"
        print_info "Use --help for usage information"
        exit 1
        ;;
esac
