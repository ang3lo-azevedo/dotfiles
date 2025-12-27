{ config, pkgs, inputs, ... }:
{
  imports = [
    # Add additional configuration modules here.
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "desktop";

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  users.users.ang3lo = {
    isNormalUser = true;
    description = "ang3lo";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      # per-user system packages
    ];
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = "24.11";
}
