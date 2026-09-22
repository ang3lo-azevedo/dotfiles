{pkgs, ...}: {
  home.packages = with pkgs; [
    libscca
  ];
}
