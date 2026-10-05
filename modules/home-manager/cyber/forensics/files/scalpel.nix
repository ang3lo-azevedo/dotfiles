{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    scalpel
  ];
}
