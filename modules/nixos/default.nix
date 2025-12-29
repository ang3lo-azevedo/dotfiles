{ inputs, ... }:
{
  # NixOS configuration modules organized by category
  imports = [
    ./common.nix
    ./gaming.nix
    ./utilities.nix
    ./virtualisation.nix
  ];
}
