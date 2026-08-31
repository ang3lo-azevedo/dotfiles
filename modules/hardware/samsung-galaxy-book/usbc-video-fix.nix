_: {
  services.udev.extraRules = ''
    # Prevent USB-C Video Adapter from taking over seat master and crashing Wayland (DRM access error)
    ATTRS{idVendor}=="25a4", ATTRS{idProduct}=="9311", TAG-="master-of-seat"
  '';
}
