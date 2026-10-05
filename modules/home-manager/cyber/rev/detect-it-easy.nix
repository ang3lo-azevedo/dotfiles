{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    detect-it-easy
  ];
}
