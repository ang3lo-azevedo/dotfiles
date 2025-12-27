{ config, pkgs, ... }:
{
  imports = [
    ../../modules/common
  ];

  networking.hostName = "server-ang3lo";
  console.keyMap = "pt-latin1";

  services.openssh.enable = true;
}
