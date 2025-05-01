#!/bin/bash

dir=$(dirname "$0")

# Source the utils
source "$dir/utils/utils.sh"

# Source the menu script
source "$dir/whiptail_menu/menu.sh"

# Main installation function
main() {    
    # Show the menu
    menu
}

# Run main function
main 