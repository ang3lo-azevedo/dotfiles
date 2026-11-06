{pkgs, ...}: {
  # Experimental nx2 (Switch 2) emulator from GitLab, packaged to wrap the
  # upstream AppImage onto the AMD eGPU under XWayland like the other forks.
  # See pkgs/ang3lo-nur/pkgs/nemyu.
  home.packages = [pkgs.nemyu];
}
