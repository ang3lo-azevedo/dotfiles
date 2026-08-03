{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    nmap
  ];
}
