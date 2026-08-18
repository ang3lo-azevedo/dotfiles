{pkgs, ...}: {
  home.packages = with pkgs; [
    mimikatz
  ];
}
