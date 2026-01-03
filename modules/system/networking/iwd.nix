{
  # Enable wireless networking with iwd
  networking.wireless.iwd.enable = true;
  networking.wireless.enable = false;

  # Tell NetworkManager to use iwd backend
  networking.networkmanager.wifi.backend = "iwd";
}