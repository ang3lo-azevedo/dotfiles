{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (callPackage ../../../../../../pkgs/registry-spy/default.nix { })
  ];
}
