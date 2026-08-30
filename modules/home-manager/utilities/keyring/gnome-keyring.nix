{pkgs, ...}: {
  home.packages = [
    pkgs.gcr
    pkgs.dconf
    pkgs.seahorse
  ];
}
