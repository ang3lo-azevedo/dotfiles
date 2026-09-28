{pkgs, ...}: let
  # Import shared extension IDs
  sharedExtensions = import ../shared-extensions.nix;
  marketplace = pkgs.nix-vscode-extensions.vscode-marketplace;

  # Map extension IDs to nix-vscode-extensions packages
  extensionIdToPackage = extId: let
    parts = pkgs.lib.splitString "." extId;
    publisher = builtins.head parts;
    name = pkgs.lib.concatStringsSep "." (builtins.tail parts);
    publisherAttr = builtins.getAttr publisher marketplace;
  in
    builtins.getAttr name publisherAttr;
in {
  programs.vscodium.profiles.default.extensions =
    map extensionIdToPackage sharedExtensions.extensionIds;
}
