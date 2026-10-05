{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    imhex
  ];
}
