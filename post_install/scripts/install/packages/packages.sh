#! /bin/bash

get_packages_from_txt() {
    local file=$1
    local packages=()
    while IFS= read -r line; do
        packages+=("$line")
    done < "$file"
    echo "${packages[@]}"
}

install_packages() {
    local packages=($(get_packages_from_txt "packages.txt"))
    sudo pacman -S --needed "${packages[@]}"
}