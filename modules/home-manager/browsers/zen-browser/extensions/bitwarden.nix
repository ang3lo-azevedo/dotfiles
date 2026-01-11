{ pkgs, profileName, ... }:
{
  # TODO: Add fingerprint unlock to bitwarden
  programs.zen-browser.profiles.${profileName}.extensions = {
    packages = [ pkgs.firefoxAddons.bitwarden-password-manager ];
  };
}
