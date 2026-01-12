{ pkgs, profileName, ... }:
{
  # TODO: Add fingerprint unlock to bitwarden
  programs.zen-browser.profiles.${profileName}.extensions = {
    packages = [ pkgs.firefoxAddons.bitwarden-password-manager ];
  };

  # Install Bitwarden desktop app for browser integration and biometric support
  home.packages = with pkgs; [
    bitwarden-desktop
  ];
}
