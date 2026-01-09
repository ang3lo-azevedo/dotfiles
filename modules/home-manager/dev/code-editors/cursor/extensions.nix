{ pkgs, ... }:
let
  # Import shared extension IDs
  sharedExtensions = import ../shared-extensions.nix;
in
{
  # Install extensions via Home Manager activation script
  # Cursor uses the same CLI as VSCode, so we can use --install-extension
  # The || true ensures that if an extension is already installed, it doesn't fail
  home.activation.installCursorExtensions = ''
    if command -v cursor >/dev/null 2>&1; then
      echo "Installing Cursor extensions..."
      ${pkgs.lib.concatMapStringsSep "\n" (extId: ''
        cursor --install-extension "${extId}" || true
      '') sharedExtensions.extensionIds}
    else
      echo "Cursor not found, skipping extension installation"
    fi
  '';
}

