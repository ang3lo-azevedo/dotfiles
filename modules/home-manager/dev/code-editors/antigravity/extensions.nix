{ pkgs, ... }:
let
  sharedExtensions = import ../shared-extensions.nix;
in
{
  home.activation.installAntigravityExtensions = ''
    if command -v antigravity >/dev/null 2>&1; then
      echo "Installing Antigravity extensions..."
      ${pkgs.lib.concatMapStringsSep "\n" (extId: ''
        antigravity --install-extension "${extId}" || true
      '') sharedExtensions.extensionIds}
    else
      echo "Antigravity not found, skipping extension installation"
    fi
  '';
}