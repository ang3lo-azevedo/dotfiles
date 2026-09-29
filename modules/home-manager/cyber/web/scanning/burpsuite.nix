{pkgs, ...}: {
  home.packages = with pkgs; [
    burpsuite-pro
  ];
}
