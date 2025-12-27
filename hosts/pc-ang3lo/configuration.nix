{ config, pkgs, ... }:
{
  imports = [
    ../../modules/common
  ];

  networking.hostName = "pc-angelo";

  services.displayManager.ly.enable = true;
}
