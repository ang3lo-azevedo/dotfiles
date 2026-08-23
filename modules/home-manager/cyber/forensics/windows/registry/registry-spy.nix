{pkgs, ...}: {
  home.packages = with pkgs; [
    registry-spy
  ];
}
