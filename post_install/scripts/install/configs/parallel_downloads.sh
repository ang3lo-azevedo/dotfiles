#!/bin/bash

# Enable parallel downloads
enable_parallel_downloads() {
    local parallel_downloads="$1"
    
    # If no parameter provided, try to get from config.json
    if [ -z "$parallel_downloads" ]; then
        parallel_downloads=$(jq -r '.parallel_downloads' config.json)
    fi

    if [ -z "$parallel_downloads" ]; then
        echo "Parallel downloads not set in config.json and no parameter provided"
        return
    fi
    sudo sed -i "s/^#ParallelDownloads = 5/ParallelDownloads = $parallel_downloads/" /etc/pacman.conf
}

# Call the function with the value from config.json if no argument is provided
enable_parallel_downloads "$1"
