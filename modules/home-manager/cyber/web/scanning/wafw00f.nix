{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    wafw00f
  ];
}
