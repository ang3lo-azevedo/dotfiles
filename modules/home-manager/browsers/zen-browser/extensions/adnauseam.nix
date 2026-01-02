{ pkgs, profileName, ... }:
{
  programs.zen-browser.profiles.${profileName}.extensions = {
    packages = [ pkgs.firefoxAddons.adnauseam ];
    settings = {
      "adnauseam@rednoise.org".settings = {
        selectedFilterLists = [
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-unbreak"
          "ublock-quick-fixes"
        ];
      };
    };
  };
}
