{
  networking = {
    wireless.iwd.enable = true;
    # wpa_supplicant and iwd conflict: both manage the same wireless interfaces
    wireless.enable = false;

    # NM delegates all Wi-Fi operations to iwd: scanning, association, key negotiation
    networkmanager.wifi.backend = "iwd";
  };
}
