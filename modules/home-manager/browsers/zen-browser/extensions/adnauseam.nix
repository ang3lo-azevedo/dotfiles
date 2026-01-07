{ pkgs, profileName, ... }:
{
  programs.zen-browser.profiles.${profileName}.extensions = {
    packages = [ pkgs.firefoxAddons.adnauseam ];
    settings = {
      "adnauseam@rednoise.org".settings = {
        "userSettings.firstInstall" = false;
        "userSettings.hidingAds" = true;
        "userSettings.clickingAds" = true;
        "userSettings.blockingMalware" = true;
        "userSettings.webrtcIPAddressHidden" = true;
        selectedFilterLists = [
          "user-filters"
          "adnauseam-filters"
          "eff-dnt-whitelist"
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-quick-fixes"
          "ublock-unbreak"
          "easylist"
          "easyprivacy"
          "urlhaus-1"
          "plowe-0"
          "fanboy-cookiemonster"
          "ublock-cookies-easylist"
          "adguard-cookies"
          "ublock-cookies-adguard"
          "easylist-chat"
          "easylist-newsletters"
          "easylist-notifications"
          "easylist-annoyances"
          "adguard-mobile-app-banners"
          "adguard-other-annoyances"
          "adguard-popup-overlays"
          "adguard-widgets"
          "ublock-annoyances"
        ];
      };
    };
  };
}
