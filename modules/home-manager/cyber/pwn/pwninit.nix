{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pwninit
  ];
}
