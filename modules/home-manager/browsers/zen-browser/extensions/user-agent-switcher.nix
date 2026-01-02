{ pkgs, profileName, ... }:
{
  programs.zen-browser.profiles.${profileName}.extensions.packages = [ pkgs.firefoxAddons.user-agent-string-switcher ];
}
