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
      extensions.force = true;
      settings = {
        general.autoScroll = true;
        browser = {
          ctrlTab.sortByRecentlyUsed = true;
          download.useDownloadDir = false;
        };
        zen = {
          workspaces.continue-where-left-off = true;
          tabs.vertical.right-side = true;
          view.compact = {
            enable-at-startup = true;
          };
          urlbar.behavior = "float";
        };
        extensions.autoDisableScopes = 0;
        pinned-tab-manager.restore-pinned-tabs-to-pinned-url = true;
      };
    };
  };
}
