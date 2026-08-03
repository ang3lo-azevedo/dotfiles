{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    evtx
  ];
}
