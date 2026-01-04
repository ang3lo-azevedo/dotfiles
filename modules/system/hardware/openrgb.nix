{ pkgs, ... }:
{
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;

  boot.kernelModules = [ "i2c-dev" "i2c-i801" ];
}
