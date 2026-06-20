{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libesedb
  ];
}
