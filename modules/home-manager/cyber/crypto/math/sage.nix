{pkgs, ...}: {
  home.packages = with pkgs; [
    sage
  ];
}
