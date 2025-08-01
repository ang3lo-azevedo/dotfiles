#!/bin/bash
waybar&
trap "killall waybar" EXIT
while inotifywait -r -e create,modify ~/.config/waybar/*; do killall -SIGUSR2 waybar; done