{pkgs, ...}: {
  home.packages = with pkgs; [
    gobuster
  ];
}
