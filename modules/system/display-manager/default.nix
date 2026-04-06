{ pkgs, lib, ... }:
{
  # Enable the Ly display manager
  services.displayManager.ly.enable = true;

  # Enable Gnome Keyring integration with Ly
  security.pam.services.ly.enableGnomeKeyring = true;

  # Enable X11 + GNOME session support
  services.xserver = {
    enable = true;
  };
  services.desktopManager.gnome.enable = false;

  # Keep only GNOME Shell essentials
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  services.gnome.gnome-initial-setup.enable = false;
  services.gnome.gnome-browser-connector.enable = false;

  # Disable evolution-data-server (pulls in webkitgtk heavily)
  services.gnome.evolution-data-server.enable = lib.mkForce false;

  # Disable online accounts (pulls in webkitgtk via evolution)
  services.gnome.gnome-online-accounts.enable = lib.mkForce false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-initial-setup
    gnome-browser-connector
  ];

  # Enable niri at system level so it appears in ly session list
  programs.niri.enable = true;
}