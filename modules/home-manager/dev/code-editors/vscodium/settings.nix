{
  lib,
  pkgs,
  config,
  ...
}: let
  sharedSettings = import ../shared-settings.nix;
  vscodiumSettings =
    builtins.removeAttrs sharedSettings.sharedSettings [
      "github.copilot.enable"
      "github.copilot.chat.cli.mcp.enabled"
    ]
    // {
      # Override color theme for VSCodium
      "workbench.colorTheme" = "Perfect Dark Theme";

      # Hides the built-in chat, inline suggestions and agent UI.
      "chat.disableAIFeatures" = true;
    };

  settingsJson = builtins.toJSON vscodiumSettings;
  settingsFile = pkgs.writeText "vscodium-settings.json" settingsJson;
in {
  # Disable profile's automatic settings management
  programs.vscodium.profiles.default.userSettings = lib.mkForce {};

  # Create writable settings file via activation script
  home.activation.vscodiumSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    settingsDir="${config.home.homeDirectory}/.config/VSCodium/User"
    settingsPath="$settingsDir/settings.json"

    # Create directory if it doesn't exist
    $DRY_RUN_CMD mkdir -p "$settingsDir"

    # Copy settings from Nix store, making it writable
    # This overwrites on each rebuild to apply Nix-defined settings
    $DRY_RUN_CMD cp -f "${settingsFile}" "$settingsPath"
    $DRY_RUN_CMD chmod u+w "$settingsPath"
  '';
}
