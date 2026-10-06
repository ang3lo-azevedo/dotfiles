{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    katana
  ];
}
