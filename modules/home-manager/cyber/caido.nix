{ pkgs, ... }:
{
  home.packages = with pkgs; [
    caido
  ];
}