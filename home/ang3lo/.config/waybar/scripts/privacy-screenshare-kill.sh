#!/usr/bin/env bash
# Destroys active PipeWire video capture stream nodes to stop screenshare/camera access.
PATH="/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH"

pw-dump 2>/dev/null |
	jq -r '.[] | select((.info.props["media.class"] // "") | test("Stream/Input/Video")) | select(.info.state == "running") | .id' |
	xargs -r -I{} pw-cli destroy {} 2>/dev/null || true
