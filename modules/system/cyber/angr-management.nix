{ pkgs, ... }:
{
  home.packages = with pkgs; [
    angr-management
  ];
}