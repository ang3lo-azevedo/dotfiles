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
        # Enable auto-scroll by middle-clicking
        general.autoScroll = true;
        browser = {
          # Enable Ctrl+Tab to switch tabs by recently used order
          ctrlTab.sortByRecentlyUsed = true;
          
          # Ask where to save each file before downloading
          download.useDownloadDir = false;

          # "Touchy" UI Density
          uidensity = 2;
        };
        zen = {
          # Restore previous session on startup
          workspaces.continue-where-left-off = true;

          # Vertical tabs on the right side
          tabs.vertical.right-side = true;

          view.compact = {
            # Enable compact mode
            enable-at-startup = true;
          };

          # Always open the URL bar in floating mode
          urlbar.behavior = "float";
        };
        
        # optional: without this the addons need to be enabled manually after first install
        extensions.autoDisableScopes = 0;

        # Restore pinned tabs to their pinned URL on startup
        pinned-tab-manager.restore-pinned-tabs-to-pinned-url = true;
      };
    };
  };
}
