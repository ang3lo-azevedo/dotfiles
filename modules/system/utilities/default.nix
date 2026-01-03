{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./ditrobox.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    gh
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
}
