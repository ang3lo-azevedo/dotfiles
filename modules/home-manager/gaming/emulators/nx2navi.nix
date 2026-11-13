{pkgs, ...}: {
  # nx2navi recompiles Ocarina of Time (Switch 2) into a native Vulkan binary from
  # your own dump. No game ships with it: it is the upstream Linux AppImage build kit,
  # wrapped with the C toolchain it expects from the system (clang, lld, sdl3/opus/
  # vpx/dav1d/zstd headers). Lives in ang3lo-nur; see pkgs/ang3lo-nur/pkgs/nx2navi.
  # Run bare for a GUI to install, update and play, or build from a .nup (made with
  # the nup tool, see ./nup.nix) on the command line:
  #   nx2navi /path/to/game.nup ~/Games/Ocarina
  # then start it with the play.sh written beside the ocarina binary. The first build
  # pip-installs zbic and, on NVIDIA, downloads DLSS (both need the internet once).
  home.packages = [pkgs.nx2navi];
}
