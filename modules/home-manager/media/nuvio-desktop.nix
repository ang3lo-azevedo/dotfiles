{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (callPackage ../../../pkgs/nuvio-desktop { })
  ];
}
