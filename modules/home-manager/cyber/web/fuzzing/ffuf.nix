{pkgs, ...}: {
  home.packages = with pkgs; [
    ffuf
  ];
}
