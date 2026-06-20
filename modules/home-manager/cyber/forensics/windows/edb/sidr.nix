{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sidr
  ];
}
