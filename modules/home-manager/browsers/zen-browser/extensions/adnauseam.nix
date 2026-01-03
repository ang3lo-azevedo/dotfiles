{ pkgs, profileName, ... }:
{
  programs.zen-browser.profiles.${profileName}.extensions = {
    packages = [ pkgs.firefoxAddons.adnauseam ];
    /*
      settings = {
        "adnauseam@rednoise.org".settings = {
          userSettings = {
              firstInstall = true;
              hidingAds = true;
              clickingAds = true;
              blockingMalware = true;
              disableHidingForDNT = false;
              disableClickingForDNT = true;
          };
        };
      };
    */
  };
}
