{pkgs, ...}: {
  # Lichii is zortos293's fork of Eglantine (Switch 2 emulator), distinct from the
  # Djihads80 fork packaged as eglantine. The package wraps the upstream AppImage to
  # run on the AMD eGPU, the same way eglantine does. See pkgs/ang3lo-nur/pkgs/lichii.
  home.packages = [pkgs.lichii];
}
