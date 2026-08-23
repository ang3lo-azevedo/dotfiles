{pkgs, ...}: {
  home.packages = with pkgs; [
    netexec
  ];
}
