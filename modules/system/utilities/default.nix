{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
  ];

  environment.systemPackages = with pkgs; [
    fastfetch
    git
    gh
    nautilus
    pavucontrol
    wlr-randr
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
}
