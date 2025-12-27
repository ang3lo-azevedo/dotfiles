{ config, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/common.nix
  ];

  networking.hostName = "pc-angelo";

  services.displayManager.ly.enable = true;
}
