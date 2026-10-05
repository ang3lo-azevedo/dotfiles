{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    pngcheck
  ];
}
