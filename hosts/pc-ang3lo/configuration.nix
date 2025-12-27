{ config, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/common.nix
  ];

  services.displayManager.ly.enable = true;
}
