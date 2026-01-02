{ inputs, lib, pkgs, ... }:
let
  profileName = "ang3lo";
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  stylix.targets.zen-browser.profileNames = [ profileName ];

  programs.zen-browser = {
    enable = true;
    profiles.${profileName} = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        adnauseam
        violentmonkey
        darkreader
        bitwarden
        # TorBox Control missing
        duckduckgo-privacy-essentials
        wayback-machine
        user-agent-string-switcher
        # Faster Pageload missing
        # Translate this page missing
        foxyproxy-standard
        clearurls
        # NopeCHA missing
      ];
      settings = {
        zen.tabs.vertical.right-side = true;
      };
    };
  };
}
