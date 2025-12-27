{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.ang3lo = {
    isNormalUser = true;
    description = "ang3lo";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = "24.11";
}
