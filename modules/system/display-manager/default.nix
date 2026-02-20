{
  # Enable the Ly display manager
  services.displayManager.ly.enable = true;

  # Enable Gnome Keyring integration with Ly
  security.pam.services.ly.enableGnomeKeyring = true;

  # Enable niri at system level so it appears in ly session list
  programs.niri.enable = true;
}