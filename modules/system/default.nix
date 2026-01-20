{
  # NixOS configuration modules organized by category
  imports = [
    ./dev
    ./display-manager
    ./gaming
    ./networking
    ./services
    ./utilities
    ./binary-cache.nix
    ./configuration.nix
    #./impermanence.nix
    ./virtualisation
    ./wayland.nix
    ./polkit_gnome.nix
    ./xdg-mime.nix
  ];
}
