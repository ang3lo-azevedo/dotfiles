{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    kerbrute
  ];
}
