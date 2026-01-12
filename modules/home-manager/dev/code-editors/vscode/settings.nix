{ lib, pkgs, config, ... }:
let
  sharedSettings = import ../shared-settings.nix;
  vscodeSettings = sharedSettings.sharedSettings // {
    # Override color theme for VSCode
    "workbench.colorTheme" = "Perfect Dark Theme";
  };
  
  settingsJson = builtins.toJSON vscodeSettings;
  settingsFile = pkgs.writeText "vscode-settings.json" settingsJson;
in
{
  # Disable profile's automatic settings management
  programs.vscode.profiles.default.userSettings = lib.mkForce {};
  
  # Create writable settings file via activation script
  home.activation.vscodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    settingsDir="${config.home.homeDirectory}/.config/Code/User"
    settingsPath="$settingsDir/settings.json"
    
    # Create directory if it doesn't exist
    $DRY_RUN_CMD mkdir -p "$settingsDir"
    
    # Copy settings from Nix store, making it writable
    # This overwrites on each rebuild to apply Nix-defined settings
    $DRY_RUN_CMD cp -f "${settingsFile}" "$settingsPath"
    $DRY_RUN_CMD chmod u+w "$settingsPath"
  '';
}
