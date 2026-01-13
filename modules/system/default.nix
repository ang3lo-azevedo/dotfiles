{
  # NixOS configuration modules organized by category
  imports = [
    ./dev
    ./display-manager
    ./gaming
    ./networking
    ./services
    ./utilities
    ./configuration.nix
    #./impermanence.nix
    ./virtualisation.nix
    ./wayland.nix
    ./polkit_gnome.nix
  ];
}
