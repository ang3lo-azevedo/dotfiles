{
  pkgs,
  lib,
  ...
}: {
  # Enable Gnome Keyring integration with Ly
  security.pam.services.ly.enableGnomeKeyring = true;

  services = {
    # Enable the Ly display manager
    displayManager.ly.enable = true;

    # Enable X11 + GNOME session support
    xserver.enable = true;
    desktopManager.gnome.enable = false;

    gnome = {
      # Keep only GNOME Shell essentials
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
      gnome-initial-setup.enable = false;
      gnome-browser-connector.enable = false;

      # Disable evolution-data-server (pulls in webkitgtk heavily)
      evolution-data-server.enable = lib.mkForce false;

      # Disable online accounts (pulls in webkitgtk via evolution)
      gnome-online-accounts.enable = lib.mkForce false;
    };
  };
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-initial-setup
    gnome-browser-connector
  ];

  # Enable niri at system level so it appears in ly session list
  programs.niri.enable = true;
}
