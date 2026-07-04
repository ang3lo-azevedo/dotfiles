{
  networking = {
    wireless = {
      # wpa_supplicant and iwd conflict: both manage the same wireless interfaces
      enable = false;
      iwd = {
        enable = true;
        settings.Scan.RandomizeMAC = true;
      };
    };

    # NM delegates all Wi-Fi operations to iwd: scanning, association, key negotiation
    networkmanager.wifi.backend = "iwd";
  };
}
