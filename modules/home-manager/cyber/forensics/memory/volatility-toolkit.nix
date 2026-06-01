{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (callPackage ../../../../../pkgs/volatility-toolkit/default.nix { })
  ];
}

