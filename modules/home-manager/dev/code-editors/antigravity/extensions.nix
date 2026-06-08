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
    
    # Remove stale extension cache files
    $DRY_RUN_CMD rm -f "$EXT_DIR/.obsolete"

    ${pkgs.lib.concatMapStringsSep "\n" (extId:
      let
        extPkg = extensionIdToPackage extId;
      in
      ''
        # Find the actual extension folder name in the Nix store (there should be only one)
        for extPath in "${extPkg}/share/vscode/extensions/"*; do
          if [ -d "$extPath" ]; then
            extName=$(basename "$extPath")
            extVersion=$(${pkgs.jq}/bin/jq -r .version "$extPath/package.json" 2>/dev/null || echo "1.0.0")
            $DRY_RUN_CMD ln -sfn "$extPath" "$EXT_DIR/$extName"
            $DRY_RUN_CMD ln -sfn "$extPath" "$EXT_DIR/$extName-$extVersion"
          fi
        done
      ''
    ) (sharedExtensions.extensionIds ++ [ "crsx.ag-usage" ])}

    # Generate extensions.json manifest so Antigravity knows about all extensions.
    # Without this, the IDE only discovers a subset when it rebuilds the manifest on startup.
    if [[ -z $DRY_RUN_CMD ]]; then
      echo "[" > "$EXT_DIR/extensions.json.tmp"
      first=1
      for extLink in "$EXT_DIR"/*/; do
        extPath=$(readlink -f "$extLink")
        [[ -d "$extPath" ]] || continue
        extName=$(basename "$extLink")
        # Only process the non-versioned symlink (no trailing -x.y.z)
        # i.e. the one whose name matches publisher.name without a version suffix
        if [[ ! "$extName" =~ ^[^.]+\.[^-]+-[0-9] ]]; then
          extId=$(${pkgs.jq}/bin/jq -r '.publisher + "." + .name | ascii_downcase' "$extPath/package.json" 2>/dev/null) || continue
          extVersion=$(${pkgs.jq}/bin/jq -r '.version' "$extPath/package.json" 2>/dev/null || echo "1.0.0")
          versionedName="''${extId}-''${extVersion}"
          if [[ $first -eq 0 ]]; then echo "," >> "$EXT_DIR/extensions.json.tmp"; fi
          first=0
          cat >> "$EXT_DIR/extensions.json.tmp" <<JSON
    {
      "identifier": { "id": "$extId" },
      "version": "$extVersion",
      "location": { "\$mid": 1, "path": "$EXT_DIR/$versionedName", "scheme": "file" },
      "relativeLocation": "$versionedName"
    }
JSON
        fi
      done
      echo "]" >> "$EXT_DIR/extensions.json.tmp"
      mv -f "$EXT_DIR/extensions.json.tmp" "$EXT_DIR/extensions.json"
      echo "Registered $(${pkgs.jq}/bin/jq 'length' "$EXT_DIR/extensions.json") extensions."
    fi
  '';
}