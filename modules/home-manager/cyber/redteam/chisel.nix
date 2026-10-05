{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    chisel
  ];
}
