{ inputs, ... }:
{
  imports = [
    ./steam
    ./gamemode.nix
    ./vr
    inputs.steam-config-nix.nixosModules.default
    inputs.nix-gaming.nixosModules.pipewire-low-latency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  # Enable Cachix for nix-gaming packages (optional but recommended)
  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };
}