{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    avml
  ];
}
