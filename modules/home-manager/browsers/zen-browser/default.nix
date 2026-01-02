{ inputs, lib, pkgs, ... }:
let
  profileName = "ang3lo";
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
    ./extensions
  ];

  _module.args.profileName = profileName;

  stylix.targets.zen-browser.profileNames = [ profileName ];

  programs.zen-browser = {
    enable = true;
    profiles.${profileName} = {
      settings = {
        zen.tabs.vertical.right-side = true;
        zen.view.compact.enable-at-startup = true;
        "extensions.autoDisableScopes" = 0;
      };
      extensions.force = true;
    };
  };
}
