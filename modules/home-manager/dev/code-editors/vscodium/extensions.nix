{pkgs, ...}: let
  # Import shared extension IDs
  sharedExtensions = import ../shared-extensions.nix;
  marketplace = pkgs.nix-vscode-extensions.vscode-marketplace;

  # VSCodium stays free of AI assistants: the other editors keep them.
  aiExtensionIds = [
    "anthropic.claude-code"
    "github.copilot-chat"
    "sst-dev.opencode"
  ];

  vscodiumOnlyExtensionIds = [
    # Snyk Security
    "snyk-security.snyk-vulnerability-scanner"
  ];

  extensionIds =
    builtins.filter (extId: !(builtins.elem extId aiExtensionIds)) sharedExtensions.extensionIds
    ++ vscodiumOnlyExtensionIds;

  # Map extension IDs to nix-vscode-extensions packages
  extensionIdToPackage = extId: let
    parts = pkgs.lib.splitString "." extId;
    publisher = builtins.head parts;
    name = pkgs.lib.concatStringsSep "." (builtins.tail parts);
    publisherAttr = builtins.getAttr publisher marketplace;
  in
    builtins.getAttr name publisherAttr;
in {
  programs.vscodium.profiles.default.extensions = map extensionIdToPackage extensionIds;
}
