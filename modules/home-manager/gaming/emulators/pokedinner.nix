{pkgs, ...}: {
  # PokeDinner, a fork of Eglantine, kept installed next to it so the two can be
  # compared. The package in ang3lo-nur wraps the upstream AppImage the same way
  # eglantine does (AMD eGPU + xcb). See pkgs/ang3lo-nur/pkgs/pokedinner.
  home.packages = [pkgs.pokedinner];
}
