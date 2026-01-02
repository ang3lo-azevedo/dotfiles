{ pkgs, profileName, ... }:
{
  programs.zen-browser.profiles.${profileName}.extensions = {
    packages = [ pkgs.firefoxAddons.adnauseam ];
    settings = {
      "adnauseam@rednoise.org".settings = {
        userSettings = {
            firstInstall = false;
            hidingAds = true;
            clickingAds = true;
            blockingMalware = true;
            disableHidingForDNT = true;
            disableClickingForDNT = true;
        };
      };
    };
  };
}
