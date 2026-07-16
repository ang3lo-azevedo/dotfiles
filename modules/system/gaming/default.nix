{inputs, ...}: {
  imports = [
    ./steam
    ./cpuid-fault.nix
    ./gamemode.nix
    ./openrgb.nix
    ./vr
    inputs.steam-config-nix.nixosModules.default
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  # Enable Cachix for nix-gaming packages (binary cache for pre-built packages like wine)
  nix.settings = {
    extra-substituters = ["https://nix-gaming.cachix.org"];
    extra-trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
}
