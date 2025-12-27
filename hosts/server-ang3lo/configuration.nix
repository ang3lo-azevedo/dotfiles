{ config, pkgs, ... }:
{
  imports = [
    ../../modules/common
  ];

  networking.hostName = "server-ang3lo";
  console.keyMap = "pt-latin1";

  users.users.t3lmo = {
    isNormalUser = true;
    description = "t3lmo";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  services.openssh.enable = true;
}
