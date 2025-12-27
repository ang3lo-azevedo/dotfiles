{ config, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/common.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/virtualisation.nix
  ];

  services.displayManager.ly.enable = true;
}
