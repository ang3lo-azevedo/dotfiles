{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
  ];

  environment.systemPackages = with pkgs; [
    fastfetch
    git
    gh
    pcmanfm
    nautilus
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
}
