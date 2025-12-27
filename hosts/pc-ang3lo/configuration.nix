{ config, pkgs, ... }:
{
  imports = [
    ../../modules/common
  ];

  networking.hostName = "pc-angelo";
}
