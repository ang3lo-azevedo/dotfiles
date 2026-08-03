{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    #qark
  ];
}
