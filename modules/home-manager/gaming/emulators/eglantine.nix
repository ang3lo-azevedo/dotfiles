{pkgs, ...}: {
  # Eglantine (Switch 2 emulator) lives in ang3lo-nur; the package there already wraps
  # it to run on the AMD eGPU. See pkgs/ang3lo-nur/pkgs/eglantine.
  home.packages = [pkgs.eglantine];
}
