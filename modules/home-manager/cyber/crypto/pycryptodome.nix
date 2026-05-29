{ pkgs, ... }:
{
  home.packages = [
    pkgs.python3Packages.pycryptodome
  ];
}
