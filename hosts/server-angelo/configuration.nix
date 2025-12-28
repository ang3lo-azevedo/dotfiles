{ config, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/common.nix
  ];

  networking.hostName = "server-angelo"; # Define your hostname.
 
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.t3lmo = {
    isNormalUser = true;
    description = "t3lmo";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  services.openssh.enable = true;
}
