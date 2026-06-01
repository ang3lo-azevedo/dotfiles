{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    (inputs.nix-gaming-edge.packages.x86_64-linux.proton-cachyos)
  ];
}
