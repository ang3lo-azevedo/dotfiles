{ lib, pkgs, config, ... }:
let
  # Import shared extension IDs
  sharedExtensions = import ../shared-extensions.nix;
  
  marketplace = pkgs.nix-vscode-extensions.vscode-marketplace;
  openvsx = pkgs.nix-vscode-extensions.open-vsx;
  
  # Map extension IDs to nix-vscode-extensions packages
  # Extension IDs are in format "publisher.name", checking marketplace first then openvsx
  extensionIdToPackage = extId:
    let
      parts = pkgs.lib.splitString "." extId;
      publisher = builtins.head parts;
      name = pkgs.lib.concatStringsSep "." (builtins.tail parts);
      
      inMarketplace = (marketplace ? ${publisher}) && (marketplace.${publisher} ? ${name});
    in
    if inMarketplace then
      marketplace.${publisher}.${name}
    else
      openvsx.${publisher}.${name};
in
{
  # Install extensions via Home Manager activation script
  # Instead of using the antigravity-ide CLI which suffers from IPC issues (drops
  # installation requests if the IDE is running) and bugs when passing --user-data-dir,
  # we symlink the extensions directly from the Nix store, similar to how the VS Code
  # module handles mutableExtensionsDir.
  home.activation.installAntigravityExtensions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Installing Antigravity extensions..."
    EXT_DIR="${config.home.homeDirectory}/.antigravity-ide/extensions"
    $DRY_RUN_CMD mkdir -p "$EXT_DIR"
    
    # Remove all existing symlinks that point to the Nix store to clean up removed extensions
    $DRY_RUN_CMD find "$EXT_DIR" -maxdepth 1 -type l -lname '/nix/store/*' -delete || true
    
    # Remove extension cache to force Antigravity to rescan
    $DRY_RUN_CMD rm -f "$EXT_DIR/extensions.json" "$EXT_DIR/.obsolete"
    
    ${pkgs.lib.concatMapStringsSep "\n" (extId:
      let
        extPkg = extensionIdToPackage extId;
      in
      ''
        # Find the actual extension folder name in the Nix store (there should be only one)
        for extPath in "${extPkg}/share/vscode/extensions/"*; do
          if [ -d "$extPath" ]; then
            extName=$(basename "$extPath")
            # VS Code requires the folder name to be publisher.name-version
            extVersion=$(${pkgs.jq}/bin/jq -r .version "$extPath/package.json" 2>/dev/null || echo "1.0.0")
            $DRY_RUN_CMD ln -sfn "$extPath" "$EXT_DIR/$extName"
            $DRY_RUN_CMD ln -sfn "$extPath" "$EXT_DIR/$extName-$extVersion"
          fi
        done
      ''
    ) (sharedExtensions.extensionIds ++ [ "crsx.ag-usage" ])}
  '';
}