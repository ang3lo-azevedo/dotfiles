{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    capa
  ];
}
