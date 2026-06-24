{
  lib,
  pkgs,
  ...
}: {
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader.systemd-boot.enable = lib.mkForce false;
  };

  environment.systemPackages = [pkgs.sbctl];
}
