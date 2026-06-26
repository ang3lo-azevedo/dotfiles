{
  pkgs,
  lib,
  inputs,
  ...
}: let
  # wine-cachyos is built with CachyOS patches and available from nix-gaming.cachix.org,
  # avoiding a full wine source build. wineWow64Packages.waylandFull is never a Hydra job
  # so it always compiles locally.
  wine = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-cachyos;
in {
  environment.systemPackages = [
    wine
    pkgs.winetricks
  ];

  # Optimizations for Wine applications
  boot.kernel.sysctl = {
    # Increase max mapped memory for Wine applications
    # Use mkDefault to avoid conflicts with platformOptimizations module
    "vm.max_map_count" = lib.mkDefault 2147483642;
  };
}
