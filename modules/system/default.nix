{
  # NixOS configuration modules organized by category
  imports = [
    ./dev
    ./display-manager
    ./gaming
    ./cyber
    ./networking
    ./services
    ./utilities
    ./binary-cache.nix
    ./configuration.nix
    #./impermanence.nix
    ./virtualization
    ./wayland.nix
    ./polkit_gnome.nix
    ./window-manager/nirinit.nix
  ];
}
