{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    poppler
  ];
}
