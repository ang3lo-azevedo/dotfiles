{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.custom-packages.packages.${pkgs.stdenv.hostPlatform.system}.playtorrio-v2
  ];
}
