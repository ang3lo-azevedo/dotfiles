{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.scrumplex-nixpkgs.legacyPackages.${pkgs.system}.wayvr
  ];
}
