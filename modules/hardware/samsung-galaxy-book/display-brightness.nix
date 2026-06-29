{pkgs, ...}: {
  hardware.i2c.enable = true;

  environment.systemPackages = [pkgs.ddcutil];
}
