{
  # NixOS configuration modules organized by category
  imports = [
    ./configuration.nix
    ./gaming.nix
    #./impermanence.nix
    ./utilities
    ./virtualisation.nix
    ./dev
  ];
}
