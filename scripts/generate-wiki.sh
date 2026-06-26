#!/usr/bin/env bash
# Generates markdown documentation for the GitHub wiki from the module tree.
# Output goes to stdout; CI redirects it to the wiki repo.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Extract package names from a .nix file's home.packages or environment.systemPackages blocks.
extract_packages() {
	local file="$1"
	{
		grep -oP '(?<=with pkgs; \[)[^\]]*' "$file" 2>/dev/null |
			tr ' ' '\n' |
			grep -v '^\s*$' |
			grep -v '^#' |
			sed 's/^[[:space:]]*//' |
			sort -u
	} || true
}

# Extract enabled services/programs from a .nix file.
extract_enables() {
	local file="$1"
	{
		grep -oP '(services|programs)\.\K[a-zA-Z0-9_-]+(?=\.enable\s*=\s*true)' "$file" 2>/dev/null |
			sort -u
	} || true
}

# Print a section header.
h2() { echo -e "\n## $1"; }
h3() { echo -e "\n### $1"; }

# Render a module directory as a wiki section.
render_module_dir() {
	local dir="$1"
	local title="$2"
	local pkgs enables

	pkgs=$(find "$dir" -name "*.nix" -exec grep -hoP '(?<=with pkgs; \[)[^\]]*' {} \; 2>/dev/null |
		tr ' ' '\n' | grep -v '^\s*$' | grep -v '^#' | sed 's/^[[:space:]]*//' | sort -u || true)

	enables=$(find "$dir" -name "*.nix" \
		-exec grep -hoP '(services|programs)\.\K[a-zA-Z0-9_-]+(?=\.enable\s*=\s*true)' {} \; 2>/dev/null |
		sort -u || true)

	if [ -z "$pkgs" ] && [ -z "$enables" ]; then return; fi

	h3 "$title"

	if [ -n "$enables" ]; then
		echo "**Enabled services / programs:**"
		echo "$enables" | while read -r name; do echo "- \`$name\`"; done
	fi

	if [ -n "$pkgs" ]; then
		echo ""
		echo "**Packages:**"
		echo "$pkgs" | while read -r pkg; do echo "- \`$pkg\`"; done
	fi
}

###############################################################################
# Home
###############################################################################

cat <<'EOF'
# NixOS Configuration

Personal NixOS configuration for `pc-angelo` (desktop / Samsung Galaxy Book laptop), managed with flakes and Home Manager.

EOF

###############################################################################
# Flake Inputs
###############################################################################

h2 "Flake Inputs"

cat <<'EOF'
| Input | Purpose |
|---|---|
| `nixpkgs` | nixos-unstable — primary package set |
| `home-manager` | User environment management |
| `agenix` | Secret management (age-encrypted secrets) |
| `disko` | Declarative disk partitioning |
| `stylix` | System-wide theming |
| `lanzaboote` | Secure Boot support |
| `impermanence` | Opt-in persistence on ephemeral root |
| `nix-cachyos-kernel` | CachyOS-patched kernel builds |
| `nix-gaming` | wine-cachyos and gaming-related packages |
| `chaotic` | Chaotic-AUR Nyx overlay (nordvpn, etc.) |
| `zen-browser` | Zen Browser flake |
| `nixcord` | Discord client configuration via Home Manager |
| `spicetify-nix` | Spotify customisation |
| `pwndbg` | Pwndbg GDB extension |
| `ida-pro-overlay` | IDA Pro packaging |
| `binaryninja` | Binary Ninja packaging |
| `proxmox-nixos` | Proxmox VE NixOS modules and overlay |
| `dmatools` | MemProcFS / DMA tooling |
| `pre-commit-hooks` | Nix-managed pre-commit hooks |
| `xddxdd-nur` | bambu-studio-bin and other NUR packages |
| `nixpkgs-xr` | OpenXR / VR packages for NixOS |
| `antigravity-nix` | Google Antigravity tool packaging |
| `samsung-galaxy-book-linux-fixes` | Kernel/module fixes for Samsung Galaxy Book (non-flake src) |
| `libfprint-src` | libfprint fork with EgisTec SDCP fingerprint support (non-flake src) |
| `firefox-addons` | Firefox add-on packages for Home Manager |
| `berberman` | berberman's flakes — provides apple-color-emoji |
| `nirinit` | nirinit Niri window manager init helper |
| `pear-desktop` | Pear Desktop (formerly youtube-music) electron app |
| `affinity-nix` | Affinity Designer/Photo/Publisher NixOS modules |
| `mpv-config` | Personal mpv configuration (non-flake src) |
| `trakt-scrobbler-src` | Trakt scrobbler source used for local package (non-flake src) |
| `angr-management` | angr-management source for local package build (non-flake src) |
| `photogimp` | PhotoGIMP assets and config (non-flake src) |
| `steam-config-nix` | Steam launch options and compatibility tool management |
| `glaumar_repo` | glaumar's NUR — provides QRookie |
| `stremio-enhanced` | Enhanced Stremio desktop client source (non-flake src) |
| `custom-packages` | Custom package flake — provides Playtorrio v2 |
| `nix-vscode-extensions` | VS Code / Cursor extension packages |
EOF

###############################################################################
# Flake Helpers
###############################################################################

h2 "Flake Helpers"

cat <<'EOF'
Two Nix helper functions are defined at the top of `flake.nix` outputs to keep host definitions concise.

**`mkNixosSystem { system, modules, specialArgs }`**
Thin wrapper around `nixpkgs.lib.nixosSystem` that forwards `system`, `modules`, and `specialArgs` verbatim.

**`mkHostConfig { stdenv, hostname, modules ? [] }`**
Builds a complete host configuration attribute set consumed by `mkNixosSystem`. It automatically:
- Sets `networking.hostName` to `hostname`.
- Includes `hosts/<hostname>/disko.nix` and the disko NixOS module when the file exists.
- Includes `hosts/<hostname>/configuration.nix`.
- Wires in the agenix NixOS module.
- Merges any extra `modules` passed by the caller (Home Manager, stylix, lanzaboote, chaotic, overlays, etc.).

Current outputs: `nixosConfigurations.pc-angelo`, `nixosConfigurations.server-angelo`, and a standalone `homeConfigurations."ang3lo"`.
EOF

###############################################################################
# Hosts
###############################################################################

h2 "Hosts"

for host_dir in "$REPO_ROOT"/hosts/*/; do
	host="$(basename "$host_dir")"
	h3 "\`$host\`"
	if [ -f "$host_dir/configuration.nix" ]; then
		echo "- Configuration: \`hosts/$host/configuration.nix\`"
	fi
	if [ -f "$host_dir/disko.nix" ]; then
		echo "- Disk layout: \`hosts/$host/disko.nix\`"
	fi
	if [ -f "$host_dir/hardware-configuration.nix" ]; then
		echo "- Hardware: \`hosts/$host/hardware-configuration.nix\`"
	fi
	# Detect hardware sub-directory (e.g. hosts/pc-angelo/hardware/galaxybook5)
	if [ -d "$host_dir/hardware" ]; then
		for hw_sub in "$host_dir/hardware"/*/; do
			[ -d "$hw_sub" ] && echo "- Hardware profile: \`hosts/$host/hardware/$(basename "$hw_sub")\`"
		done
	fi
	# pc-angelo-win is an Ansible/WinPE-based host, not a NixOS configuration
	if [ "$host" = "pc-angelo-win" ]; then
		echo "- _Windows host managed via Ansible (bootstrap.ps1 + playbook.yml) — no NixOS configuration._"
	fi
	# server-angelo: list notable services imported in configuration.nix
	if [ "$host" = "server-angelo" ] && [ -f "$host_dir/configuration.nix" ]; then
		echo "- Services: Proxmox VE, AdGuard Home, Vaultwarden, Redis, Minecraft Server, Docker Compose stacks"
	fi
done

###############################################################################
# Custom Packages
###############################################################################

h2 "Custom Packages"
echo ""
cat <<'MARKDOWN'
Packages defined locally in `pkgs/`, not available in nixpkgs:
MARKDOWN
echo ""

for pkg_dir in "$REPO_ROOT"/pkgs/*/; do
	pkg="$(basename "$pkg_dir")"
	[[ $pkg == "_sources" ]] && continue
	[[ $pkg == "nvfetcher.toml" ]] && continue
	echo "- \`$pkg\`"
done

# nvfetcher-tracked sources
if [ -f "$REPO_ROOT/pkgs/_sources/generated.json" ]; then
	echo ""
	echo "**nvfetcher-tracked sources:**"
	python3 -c "
import json, sys
with open('$REPO_ROOT/pkgs/_sources/generated.json') as f:
    d = json.load(f)
for name, info in sorted(d.items()):
    ver = info.get('version', 'unknown')
    print(f'- \`{name}\` {ver}')
" 2>/dev/null || true
fi

###############################################################################
# Overlays
###############################################################################

h2 "Overlays"
echo ""
cat <<'MARKDOWN'
Nixpkgs overlays live in `overlays/` and are applied per-host in `flake.nix`.
MARKDOWN
echo ""

for overlay_file in "$REPO_ROOT"/overlays/*.nix; do
	[ -f "$overlay_file" ] || continue
	name="$(basename "$overlay_file" .nix)"
	echo "- \`overlays/$name.nix\` — $(grep -m1 '#' "$overlay_file" 2>/dev/null | sed 's/^[# ]*//' || echo "$name overlay")"
done

###############################################################################
# System Modules
###############################################################################

h2 "System Modules"

for category in display-manager gaming networking services utilities virtualization window-manager cyber dev; do
	dir="$REPO_ROOT/modules/system/$category"
	[ -d "$dir" ] && render_module_dir "$dir" "$category"
done

# Standalone system modules
h3 "Core"
for f in configuration.nix secure-boot.nix impermanence.nix reduce-disk-usage.nix binary-cache.nix auto-upgrade.nix pc.nix; do
	fp="$REPO_ROOT/modules/system/$f"
	[ -f "$fp" ] && {
		enables=$(extract_enables "$fp")
		[ -n "$enables" ] && echo "$enables" | while read -r e; do echo "- \`$e\`"; done
	}
done

###############################################################################
# Home Manager Modules
###############################################################################

h2 "Home Manager Modules"

for category in browsers utilities window-manager media gaming cyber dev theming virtualization uni; do
	dir="$REPO_ROOT/modules/home-manager/$category"
	[ -d "$dir" ] && render_module_dir "$dir" "$category"
done

###############################################################################
# Hardware Modules
###############################################################################

h2 "Hardware Modules"
echo ""
cat <<'MARKDOWN'
Reusable hardware modules live in `modules/hardware/` and are imported by host configurations.
MARKDOWN
echo ""

# Top-level standalone hardware modules
for f in "$REPO_ROOT"/modules/hardware/*.nix; do
	[ -f "$f" ] || continue
	name="$(basename "$f" .nix)"
	echo "- \`modules/hardware/$name.nix\`"
done

# Sub-profile directories (e.g. samsung-galaxy-book)
for hw_sub in "$REPO_ROOT"/modules/hardware/*/; do
	[ -d "$hw_sub" ] || continue
	hw_name="$(basename "$hw_sub")"
	h3 "\`$hw_name\`"
	find "$hw_sub" -name "*.nix" | sort | while read -r nf; do
		rel="${nf#"$REPO_ROOT/"}"
		echo "- \`$rel\`"
	done
	enables=$(find "$hw_sub" -name "*.nix" \
		-exec grep -hoP '(services|programs)\.\K[a-zA-Z0-9_-]+(?=\.enable\s*=\s*true)' {} \; 2>/dev/null |
		sort -u || true)
	if [ -n "$enables" ]; then
		echo ""
		echo "  **Enabled services / programs:**"
		echo "$enables" | while read -r e; do echo "  - \`$e\`"; done
	fi
done

###############################################################################
# Footer
###############################################################################

echo ""
echo "---"
cat <<'MARKDOWN'
_Generated automatically by `scripts/generate-wiki.sh` — do not edit manually._
MARKDOWN
