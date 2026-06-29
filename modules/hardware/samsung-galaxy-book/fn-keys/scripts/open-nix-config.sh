#!/usr/bin/env bash
set -euo pipefail
for socket in /run/user/[0-9]*/niri/socket; do
	[ -S "$socket" ] || continue
	# shellcheck disable=SC2016
	NIRI_SOCKET="$socket" niri msg action spawn -- sh -c 'exec "$EDITOR" ~/nix-config'
	break
done
