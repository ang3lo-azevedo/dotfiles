{
  networking = {
    # Enable wireless networking with iwd
    wireless.iwd.enable = true;
    wireless.enable = false;

    # Tell NetworkManager to use iwd backend
    networkmanager.wifi.backend = "iwd";
  };
}
