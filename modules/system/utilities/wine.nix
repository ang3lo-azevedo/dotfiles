{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [
    pkgs.wineWow64Packages.full
    pkgs.winetricks
  ];

  # Optimizations for Wine applications
  boot.kernel.sysctl = {
    # Increase max mapped memory for Wine applications
    # Use mkDefault to avoid conflicts with platformOptimizations module
    "vm.max_map_count" = lib.mkDefault 2147483642;
  };
}
