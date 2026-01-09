{ pkgs, ... }:
let
  # Import shared extension IDs
  sharedExtensions = import ../shared-extensions.nix;
  
  marketplace = pkgs.nix-vscode-extensions.vscode-marketplace;
  
  # Map extension IDs to nix-vscode-extensions packages
  # Extension IDs are in format "publisher.name", which maps to marketplace.publisher.name
  # We split by the first dot to get publisher and name, then access the nested attribute
  extensionIdToPackage = extId:
    let
      parts = pkgs.lib.splitString "." extId;
      publisher = builtins.head parts;
      name = pkgs.lib.concatStringsSep "." (builtins.tail parts);
      # Access nested attribute: marketplace.publisher.name
      publisherAttr = builtins.getAttr publisher marketplace;
    in
    builtins.getAttr name publisherAttr;
in
{
  programs.vscode.profiles.default.extensions = 
    map extensionIdToPackage sharedExtensions.extensionIds;
}
