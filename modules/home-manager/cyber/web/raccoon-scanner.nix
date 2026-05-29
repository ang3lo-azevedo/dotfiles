{ pkgs, ... }:
{
  home.packages = with pkgs; [
    raccoon-scanner
  ];
}