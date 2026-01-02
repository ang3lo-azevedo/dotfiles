{ pkgs, profileName, ... }:
{
  programs.zen-browser.profiles.${profileName}.extensions.packages = [ pkgs.firefoxAddons.duckduckgo-for-firefox ];
}
