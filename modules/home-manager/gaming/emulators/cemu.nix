{pkgs, ...}: {
  home.packages = with pkgs; [
    cemu
  ];
}
