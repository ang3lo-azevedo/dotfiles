{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    stegsolve
  ];
}
