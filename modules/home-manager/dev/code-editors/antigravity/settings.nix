{ config, pkgs, lib, ... }:
let
  sharedSettings = import ../shared-settings.nix;
  antigravitySettings = builtins.removeAttrs sharedSettings.sharedSettings [
    "terminal.integrated.shell.linux"
    "terminal.external.linuxExec"
  ] // {
    "workbench.colorTheme" = "Perfect Dark Theme";
  };

  settingsFile = pkgs.writeText "antigravity-settings.json" (builtins.toJSON antigravitySettings);
in
{
  home.activation.antigravitySettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settingsDir="${config.home.homeDirectory}/.config/Antigravity/User"
    settingsPath="$settingsDir/settings.json"

    $DRY_RUN_CMD mkdir -p "$settingsDir"
    $DRY_RUN_CMD cp -f "${settingsFile}" "$settingsPath"
    $DRY_RUN_CMD chmod u+w "$settingsPath"
  '';
}