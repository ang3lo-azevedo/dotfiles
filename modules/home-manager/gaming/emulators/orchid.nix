{pkgs, ...}: {
  # Very experimental nx2 (Switch 2) emulator, packaged to wrap the upstream
  # AppImage onto the AMD eGPU under XWayland like the other Eden-derived forks.
  # See pkgs/ang3lo-nur/pkgs/orchid.
  home.packages = [pkgs.orchid];
}
