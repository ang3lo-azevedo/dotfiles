{
  # NixOS configuration modules organized by category
  imports = [
    ./configuration.nix
    ./gaming.nix
    ./utilities
    ./virtualisation.nix
    ./dev
  ];
}
