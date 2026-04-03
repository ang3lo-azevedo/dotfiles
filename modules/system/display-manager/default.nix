{ pkgs, ... }:
{
  # Enable the Ly display manager
  services.displayManager.ly.enable = true;

  # Enable Gnome Keyring integration with Ly
  security.pam.services.ly.enableGnomeKeyring = true;

  # Enable X11 + GNOME session support
  services.xserver = {
    enable = true;
  };
  services.desktopManager.gnome.enable = true;

  # Keep only GNOME Shell essentials
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  # Enable niri at system level so it appears in ly session list
  programs.niri.enable = true;
}