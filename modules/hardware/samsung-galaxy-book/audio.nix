{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    "${inputs.samsung-galaxy-book-linux-fixes}/nixos/samsung-speaker-fix.nix"
  ];

  # Prevent the service from deleting I2C devices when it stops (e.g. when Thunderbolt is unplugged and sound.target is affected)
  # Deleting the I2C devices while the audio driver is active causes a kernel panic/freeze.
  systemd.services.max98390-hda-i2c-setup.serviceConfig.ExecStop = lib.mkForce "${pkgs.coreutils}/bin/true";
}
