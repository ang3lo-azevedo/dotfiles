{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    # Wine with both 32-bit and 64-bit support for Wayland
    wineWow64Packages.waylandFull
    
    # Wine tools for managing prefixes and tweaks
    winetricks
  ];

  # Optimizations for Wine applications
  boot.kernel.sysctl = {
    # Increase max mapped memory for Wine applications
    # Use mkDefault to avoid conflicts with platformOptimizations module
    "vm.max_map_count" = lib.mkDefault 2147483642;
  };
}
