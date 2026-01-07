{
  # NixOS configuration modules organized by category
  imports = [
    ./configuration.nix
    ./gaming
    #./impermanence.nix
    ./utilities
    ./virtualisation.nix
    ./dev
    ./window-manager
  ];
}
