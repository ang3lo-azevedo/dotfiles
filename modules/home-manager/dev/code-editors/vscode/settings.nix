{ lib, ... }:
let
  sharedSettings = import ../shared-settings.nix;
in
{
  programs.vscode.profiles.default.userSettings = sharedSettings.sharedSettings // {
    # Override color theme with mkForce for VSCode
    "workbench.colorTheme" = lib.mkForce "Perfect Dark Theme";
  };
}
