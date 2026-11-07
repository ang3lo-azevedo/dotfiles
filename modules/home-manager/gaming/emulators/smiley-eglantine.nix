{pkgs, ...}: {
  # SmileyTatsu's Eglantine fork (Switch 2 emulator), packaged in ang3lo-nur to
  # wrap the upstream AppImage onto the AMD eGPU under XWayland like the other
  # Eden-derived forks. It brands as "Eglantine", so it shares the pooled data
  # store (see shared-data.nix). See pkgs/ang3lo-nur/pkgs/smiley-eglantine.
  home.packages = [pkgs.smiley-eglantine];
}
