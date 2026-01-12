{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wayvr
  ];
}
