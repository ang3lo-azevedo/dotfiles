{
  # NixOS configuration modules organized by category
  imports = [
    ./dev
    ./display-manager
    ./gaming
    ./networking/networkmanager.nix
    ./services
    ./utilities
    ./configuration.nix
    #./impermanence.nix
    ./virtualisation.nix
    ./wayland.nix
    ./polkit_gnome.nix
  ];
}
