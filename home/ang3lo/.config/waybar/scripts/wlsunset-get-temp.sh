#!/usr/bin/env bash
cat "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wlsunset-night-temp" 2>/dev/null || echo 3500
