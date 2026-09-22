{inputs, ...}: {
  imports = [
    ./steam
    ./cpuid-fault.nix
    ./gamemode.nix
    ./openrgb.nix
    ./vr
    inputs.steam-config-nix.nixosModules.default
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  # The nix-gaming cache is declared once in modules/system/binary-cache.nix.
  # Repeating it here made it appear twice in the resolved substituter list.
}
