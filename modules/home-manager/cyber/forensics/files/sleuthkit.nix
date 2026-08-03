{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    sleuthkit
  ];
}
