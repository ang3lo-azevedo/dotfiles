{pkgs, ...}: {
  home.packages = with pkgs; [
    faugus-launcher
  ];
}
