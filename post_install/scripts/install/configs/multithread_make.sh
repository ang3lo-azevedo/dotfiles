#!/bin/bash

# Enable multithreaded make
multithread_make() {
    local cpu_cores=$1
    sudo sed -i "s/^#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$cpu_cores\"/" /etc/makepkg.conf
}