{ inputs, ... }:
{
  # NixOS configuration modules organized by category
  imports = [
    ./gaming.nix
    ./utilities.nix
    ./virtualization.nix
  ];
}
