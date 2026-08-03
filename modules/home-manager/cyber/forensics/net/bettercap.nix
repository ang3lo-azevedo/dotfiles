{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    bettercap
  ];
}
