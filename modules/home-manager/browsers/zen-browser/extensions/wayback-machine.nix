{ pkgs, profileName, ... }:
{
  programs.zen-browser.profiles.${profileName}.extensions.packages = [ pkgs.firefoxAddons.wayback-machine_new ];
}
