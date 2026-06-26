#!/usr/bin/env bash
devices=$(kdeconnect-cli -l 2>/dev/null | grep "reachable")
[ -z "$devices" ] && exit 1
name=$(echo "$devices" | sed 's/^- //; s/: .*//' | paste -sd ', ')
printf '{"text":"\ued09 ","tooltip":"%s"}\n' "$name"
