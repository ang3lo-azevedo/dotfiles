{
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd.systemd.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
      measuredBoot = {
        enable = true;
        pcrs = [0 4 7];
      };
    };
    loader.systemd-boot = {
      enable = lib.mkForce false;
      configurationLimit = lib.mkForce 8;
    };
  };

  environment.systemPackages = [pkgs.sbctl];
}
