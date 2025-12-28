{ config, pkgs, ... }:
{
  imports = [

    ../../modules/nixos/common.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/virtualisation.nix
  ];

  networking.hostName = "pc-angelo"; # Define your hostname.
  
  services.displayManager.ly.enable = true;
}
