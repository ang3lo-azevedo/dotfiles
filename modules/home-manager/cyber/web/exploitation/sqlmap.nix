{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    sqlmap
  ];
}
