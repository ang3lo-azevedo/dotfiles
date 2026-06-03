{ lib, pkgs, config, ... }:
let
  sharedSettings = import ../shared-settings.nix;
  antigravitySettings = sharedSettings.sharedSettings // {
    # Override color theme for Antigravity
    "workbench.colorTheme" = "Perfect Dark Theme";
  };

  settingsJson = builtins.toJSON antigravitySettings;
  settingsFile = pkgs.writeText "antigravity-settings.json" settingsJson;
in
{
  # Create writable settings file via activation script
  # This applies Nix settings on rebuild but keeps the file writable so the IDE doesn't complain
  home.activation.antigravitySettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    settingsDir="${config.home.homeDirectory}/.antigravity-ide/User"
    settingsPath="$settingsDir/settings.json"

    # Create directory if it doesn't exist
    $DRY_RUN_CMD mkdir -p "$settingsDir"

    # Copy settings from Nix store, making it writable
    $DRY_RUN_CMD cp -f "${settingsFile}" "$settingsPath"
    $DRY_RUN_CMD chmod u+w "$settingsPath"
  '';
}