{pkgs, ...}: {
  home.packages = with pkgs; [
    analyzeMFT
  ];
}
