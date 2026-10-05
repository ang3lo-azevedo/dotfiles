{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    haiti
  ];
}
