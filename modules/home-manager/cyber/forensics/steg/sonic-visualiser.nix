{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    sonic-visualiser
  ];
}
