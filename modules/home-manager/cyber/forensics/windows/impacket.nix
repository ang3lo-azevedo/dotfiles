{pkgs, ...}: {
  home.packages = with pkgs.unstable.python3Packages; [
    impacket
  ];
}
