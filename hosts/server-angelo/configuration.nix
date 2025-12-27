{ config, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/common.nix
  ];

  console.keyMap = "pt-latin1";

  users.users.t3lmo = {
    isNormalUser = true;
    description = "t3lmo";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  services.openssh.enable = true;
}
