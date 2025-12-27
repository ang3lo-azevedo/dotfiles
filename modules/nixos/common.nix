{ config, pkgs, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # Allow non-root users to use Nix
    trusted-users = [ "root" "ang3lo" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "pt-latin1";

  users.users.ang3lo = {
    isNormalUser = true;
    description = "ang3lo";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  system.stateVersion = "24.11";
}
