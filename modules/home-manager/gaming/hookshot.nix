{pkgs, ...}: {
  # Hookshot: native static recompilation of Ocarina of Time (Switch 2 remake).
  # The package wraps the upstream builder AppImage onto the AMD eGPU. Run
  # `hookshot` to open the builder (point it at your own game files to build),
  # then `hookshot --play`. See pkgs/ang3lo-nur/pkgs/hookshot.
  home.packages = [pkgs.hookshot];
}
